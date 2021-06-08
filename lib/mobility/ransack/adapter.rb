# frozen_string_literal: true

require 'ransack'

module Mobility
  module Ransack
    module Adapter
      def result(*args, &block)
        sorted = sorts.inject(super) do |relation, sort|
          apply_mobility_scope(relation, ordering_mobility_attributes(sort))
        end

        conditions.inject(sorted) do |relation, condition|
          apply_mobility_scope(relation, condition_mobility_attributes(condition.arel_predicate))
        end
      end

      private

      def apply_mobility_scope(relation, attr_tuples)
        attr_tuples.inject(relation) do |i18n_rel, (predicate, attr)|
          attr.backend_class.apply_scope(i18n_rel, predicate)
        end
      end

      def condition_mobility_attributes(predicate, acc = [])
        case predicate
        when ::Arel::Nodes::Grouping
          condition_mobility_attributes(predicate.expr, acc)
        when ::Arel::Nodes::Binary
          [predicate.left, predicate.right].each do |side|
            if side.is_a?(::Mobility::Arel::Attribute)
              acc.push([predicate, side])
            elsif side.is_a?(::Arel::Nodes::Node)
              condition_mobility_attributes(side, acc)
            end
          end
        end
        acc
      end

      def ordering_mobility_attributes(sort)
        predicate = ::Ransack::Visitor.new.visit_Ransack_Nodes_Sort(sort)
        is_mobility = predicate.is_a?(::Arel::Nodes::Ordering) && predicate.expr.is_a?(::Mobility::Arel::Attribute)
        is_mobility ? [[predicate, predicate.expr]] : []
      end

      ::Ransack::Search.prepend self
    end
  end
end
