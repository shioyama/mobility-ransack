require "mobility/ransack/version"
require "mobility/plugins/arel"
require "ransack"

module Mobility
  module Ransack
    class Visitor < Mobility::Plugins::Arel::Visitor
      def initialize
        super(nil, nil)
      end

      private

      def visit_collection(objects)
        objects.map(&method(:visit)).sum([]).uniq
      end
      alias :visit_Array :visit_collection
      alias :visit_Arel_Nodes_Equality :visit_Arel_Nodes_Binary
      alias :visit_Arel_Nodes_Or :visit_Arel_Nodes_Binary

      def visit_Mobility_Plugins_Arel_Attribute(object)
        [[object.backend_class, object.locale]]
      end

      def visit_default(*)
        []
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
        visitor.accept(predicate).inject(relation) do |i18n_rel, (backend_class, locale)|
          backend_class.apply_scope(i18n_rel, predicate, locale)
        end
      end

      def visitor
        @visitor ||= Visitor.new
      end
    end

    ::Ransack::Search.prepend Search
  end
end
