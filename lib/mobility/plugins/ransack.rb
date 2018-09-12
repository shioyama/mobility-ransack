require "ransack"
require "mobility"

module Mobility
  module Plugins
    module Ransack
      # Applies ransack plugin.
      # @param [Attributes] attributes
      # @param [Boolean] option
      def self.apply(attributes, option)
        if option
          backend_class = attributes.backend_class
          plugin = self
          attributes.model_class.class_eval do
            attributes.each do |attr|
              ransacker(attr) { backend_class.build_node(attr, Mobility.locale) }
            end
            extend plugin
          end
        end
      end

      def ransack(params = {}, options = {})
        Search.new(self, params, options)
      end

      class Search < ::Ransack::Search
        def result(opts = {})
          sorted = sorts.inject(super) do |relation, sort|
            predicate = ::Ransack::Visitor.new.visit_Ransack_Nodes_Sort(sort)
            apply_scope(relation, predicate, [sort.attr_name])
          end
          conditions.inject(sorted) do |relation, condition|
            apply_scope(relation, condition.arel_predicate, condition.attributes.compact.flatten.map(&:name))
          end
        end

        private

        def apply_scope(relation, predicate, attributes)
          (attributes & object.mobility_attributes).inject(relation) do |i18n_rel, attr|
            object.mobility_backend_class(attr).apply_scope(i18n_rel, predicate)
          end
        end
      end
    end
  end
end
