module RadioTune
  module TestStubs
    def database_adapter_stub(return_value)
      DatabaseAdapterStub.new(return_value)
    end

    class DatabaseAdapterStub
      def initialize(return_value)
        @queries = []
        @return_value = return_value
      end

      def last_query
        @queries.last
      end

      def execute(sql)
        @return_value.tap do
          @queries << sql
        end
      end
    end
  end
end

module MTest
  class Unit
    class TestCase
      include RadioTune::TestStubs
    end
  end
end
