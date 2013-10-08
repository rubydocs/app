module Services
  class Base
    class << self
      def call(*args)
        self.new.call(*args)
      end
    end

    def call
      raise NotImplementedError
    end
  end
end
