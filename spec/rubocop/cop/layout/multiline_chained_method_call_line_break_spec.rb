# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::MultilineChainedMethodCallLineBreak, :config do
  context 'when receiver spans multiple lines' do
    it 'registers an offense and corrects chained method call on the same line' do
      expect_offense(<<~RUBY)
        some_method_call(arg1,
                         arg2).chained_call
                              ^ Place the chained method call on a new line.
      RUBY

      expect_correction(<<~RUBY)
        some_method_call(arg1,
                         arg2)
          .chained_call
      RUBY
    end

    it 'does not register an offense for chained method call on a new line' do
      expect_no_offenses(<<~RUBY)
        some_method_call(arg1,
                         arg2)
          .chained_call
      RUBY
    end
  end

  context 'when receiver is a single line' do
    it 'does not register an offense for chained method call on the same line' do
      expect_no_offenses(<<~RUBY)
        some_method_call(arg1, arg2).chained_call
      RUBY
    end
  end

  context 'when receiver is implicit self inside method definition' do
    it 'registers an offense and corrects chained method call on the same line' do
      expect_offense(<<~RUBY)
        def some_method
          another_method(arg1,
                         arg2).chained_call
                              ^ Place the chained method call on a new line.
        end
      RUBY

      expect_correction(<<~RUBY)
        def some_method
          another_method(arg1,
                         arg2)
            .chained_call
        end
      RUBY
    end

    it 'does not register an offense for chained method call on a new line' do
      expect_no_offenses(<<~RUBY)
        def some_method
          another_method(arg1,
                         arg2)
            .chained_call
        end
      RUBY
    end
  end

  context 'when receiver is implicit self inside singleton method definition' do
    it 'registers an offense and corrects chained method call on the same line' do
      expect_offense(<<~RUBY)
        def self.some_method
          another_method(arg1,
                         arg2).chained_call
                              ^ Place the chained method call on a new line.
        end
      RUBY

      expect_correction(<<~RUBY)
        def self.some_method
          another_method(arg1,
                         arg2)
            .chained_call
        end
      RUBY
    end

    it 'does not register an offense for chained method call on a new line' do
      expect_no_offenses(<<~RUBY)
        def self.some_method
          another_method(arg1,
                         arg2)
            .chained_call
        end
      RUBY
    end
  end

  context 'when receiver is a block' do
    it 'registers an offense and corrects chained method call on the same line' do
      expect_offense(<<~RUBY)
        block_method do
          perform_action
        end.another_method
           ^ Place the chained method call on a new line.
      RUBY

      expect_correction(<<~RUBY)
        block_method do
          perform_action
        end
          .another_method
      RUBY
    end

    it 'does not register an offense for chained method call on a new line' do
      expect_no_offenses(<<~RUBY)
        block_method do
          perform_action
        end
          .another_method
      RUBY
    end
  end
end
