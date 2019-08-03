module RadioTune
  class BaseCommand
    class << self
      def call(*args)
        new.call(*args)
      end
    end
  end
end
