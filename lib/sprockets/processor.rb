require 'tilt'

module Sprockets
  # `Processor` creates an anonymous processor class from a block.
  #
  #     register_preprocessor 'text/css', :my_processor do |context, data|
  #       # ...
  #     end
  #
  class Processor < Tilt::Template
    def self.make_processor(klass, &block) # :nodoc:
      return klass unless block_given?

      name  = klass.to_s
      Class.new(Processor) do
        @name      = name
        @processor = block
      end
    end

    # `processor` is a lambda or block
    def self.processor
      @processor
    end

    def self.name
      "Sprockets::Processor (#{@name})"
    end

    def self.to_s
      name
    end

    def prepare
    end

    # Call processor block with `context` and `data`.
    def evaluate(context, locals)
      self.class.processor.call(context, data)
    end
  end
end
