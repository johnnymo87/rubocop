# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      # This cop checks that each method call in a chain starts on a new line
      # if the receiver's method call spans multiple lines.
      class MultilineChainedMethodCallLineBreak < Base
        include Alignment
        extend AutoCorrector

        MSG = 'Place the chained method call on a new line.'

        def on_send(node)
          return unless node.parent&.send_type? || node.parent&.def_type? || node.parent&.defs_type?

          receiver = node.receiver
          # If the receiver is nil, it might be an implicit self, check if the parent is a method definition
          if receiver.nil?
            return unless implicit_self_receiver?(node)
            receiver = implicit_self_receiver(node)
          end

          return unless receiver.multiline?

          dot = node.loc.dot
          return unless dot.line == receiver.last_line

          add_offense(dot) do |corrector|
            AlignmentCorrector.correct(corrector, processed_source, node, -dot.column)
          end
        end

        private

        # Check if the node is the first method call in a chain inside a method definition
        def implicit_self_receiver?(node)
          parent = node.parent
          parent&.def_type? || parent&.defs_type?
        end

        # Create a fake receiver node representing implicit self
        def implicit_self_receiver(node)
          source_range = node.loc.selector || node.loc.operator
          Parser::Source::Range.new(source_range.source_buffer, source_range.begin_pos, source_range.begin_pos)
        end
      end
    end
  end
end

