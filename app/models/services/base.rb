module Services
  class Base
    class << self
      def inherited(subclass)
        subclass.send :include, Asyncable
        subclass.const_set :Error, Class.new(StandardError)
      end

      delegate :call, to: :new
    end

    def call
      raise NotImplementedError
    end
  end
end
