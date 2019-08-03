module RadioTune
  class DatabaseAdapter
    def initialize(database)
      @database = database
    end

    def execute(sql)
      connection.execute(sql)
    end

    def close
      connection.close
    end

    private

    attr_reader :database

    def connection
      @connection ||= SQLite3::Database.new(database)
    end
  end
end
