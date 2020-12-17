require "ransack"
require "mobility"

module Mobility
  module Plugins
    module Ransack
      extend Plugin

      default true
      requires :backend, include: :before
      requires :active_record

      # Applies ransack plugin.
      # @param [Attributes] attributes
      # @param [Boolean] option
      included_hook do |klass, backend_class|
        if options[:ransack]
          names.each do |name|
            klass.ransacker(name) { backend_class.build_node(name, Mobility.locale) }
          end
          klass.extend ClassMethods
        end
      end

      module ClassMethods
        def ransack(*)
          super.extend(Search)
        end
      end

      module Search
        def result(opts = {})
          sorted = sorts.inject(super) do |relation, sort|
            predicate = ::Ransack::Visitor.new.visit_Ransack_Nodes_Sort(sort)
            apply_mobility_scope(relation, predicate, [sort.attr_name])
          end
          conditions.inject(sorted) do |relation, condition|
            apply_mobility_scope(relation, condition.arel_predicate, condition.attributes.compact.flat_map(&:name))
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
