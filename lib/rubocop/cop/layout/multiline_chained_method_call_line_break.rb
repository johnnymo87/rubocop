# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      # Mandates that in a method chain, if the initial method call extends
      # over multiple lines due to its arguments or an accompanying block, then
      # subsequent methods must commence on new lines.
      #
      # @example
      #  # bad
      #  foo.bar(a,
      #          b).baz
      #
      #  # bad
      #  foo.bar(
      #    a,
      #    b).baz
      #
      #  # good
      #  foo.bar(
      #    a,
      #    b
      #  )
      #  .baz
      #
      #  # good
      #  foo
      #    .bar(a, b)
      #    .baz
      #
      #  # good
      #  foo.bar(a, b)
      #      .baz
      class MultilineChainedMethodCallLineBreak < Base
        include Alignment
        extend AutoCorrector

        MSG = 'Place the chained method call on a new line.'

        def on_send(node)
          # Skip root send nodes without a receiver (method calls on implicit self)
          return unless node.receiver

          receiver = node.receiver
          return unless receiver.multiline?

          dot = node.loc.dot
          return unless dot.line == receiver.last_line

          add_offense(dot) do |corrector|
            corrector.insert_before(dot, "\n")
            # AlignmentCorrector.correct(corrector, processed_source, node, -dot.column)
            AlignmentCorrector.correct(corrector, processed_source, node, -dot.column)
          end
        end
      end
    end
  end
end
