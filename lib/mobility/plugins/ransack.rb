require "ransack"
require "mobility"

module Mobility
  module Plugins
    module Ransack
      extend Plugin

      # Applies ransack plugin.
      # @param [Attributes] attributes
      # @param [Boolean] option
      def self.apply(attributes, option)
        if option
          backend_class, model_class = attributes.backend_class, attributes.model_class
          attributes.each do |attr|
            model_class.ransacker(attr) { backend_class.build_node(attr, Mobility.locale) }
          end
          model_class.extend self
        end
      end

      def ransack(*)
        super.extend(Search)
      end

      module Search
        def result(opts = {})
          sorted = sorts.inject(super) do |relation, sort|
            predicate = ::Ransack::Visitor.new.visit_Ransack_Nodes_Sort(sort)
            apply_mobility_scope(relation, predicate, [sort.attr_name])
          end
          conditions.inject(sorted) do |relation, condition|
            apply_mobility_scope(relation, condition.arel_predicate, condition.attributes.compact.flatten.map(&:name))
          end
        end

        private

        def apply_mobility_scope(relation, predicate, attributes)
          (attributes & object.mobility_attributes).inject(relation) do |i18n_rel, attr|
            object.mobility_backend_class(attr).apply_scope(i18n_rel, predicate)
          end
        end
      end
    end

    register_plugin(:ransack, Ransack)
  end
end
