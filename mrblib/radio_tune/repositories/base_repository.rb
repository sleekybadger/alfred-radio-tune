module RadioTune
  class BaseRepository
    class << self
      def table(id, table, **columns)
        instance_variable_set "@#{id}", Table.new(table, columns)

        define_method "#{id}_table" do
          self.class.instance_variable_get "@#{id}"
        end
      end
    end

    def build_query(&block)
      Query.new(&block)
    end

    class Table
      attr_reader :name

      def initialize(name, columns)
        @name = name
        @columns = columns
      end

      def method_missing(method_name, *args, &block)
        columns[method_name] || super
      end

      def respond_to_missing?(method_name)
        columns.key?(method_name) || super
      end

      def prefixed
        @prefixed ||= self.class.new(
          name, columns.transform_values { |column| "#{name}.#{column}" }
        )
      end

      def values_at(*args)
        columns.values_at(*args)
      end

      private

      attr_reader :columns
    end

    class Query
      STATEMENT_ENDER = ";".freeze

      def initialize
        @params = {}
        @statements = []

        yield self if block_given?
      end

      def select(*columns)
        statements << "SELECT #{columns.join(', ')}"
      end

      def from(table)
        statements << "FROM #{table}"
      end

      def join(table, left_column, right_column)
        statements << "INNER JOIN #{table} ON #{left_column} = #{right_column}"
      end

      def like(column, value)
        statements << "WHERE #{column} LIKE '#{value}'"
      end

      def order_by(column, sort)
        statements << "ORDER BY #{column} #{sort}"
      end

      def limit(value)
        statements << "LIMIT #{value}"
      end

      def update(table)
        statements << "UPDATE #{table}"
      end

      def set(*updates)
        update_statements = updates.map do |update|
          "#{update.first} = '#{update.last}'"
        end

        statements << "SET #{update_statements.join(', ')}"
      end

      def where(column, value)
        statements << "WHERE #{column} = '#{value}'"
      end

      def to_sql
        [statements.join(" "), STATEMENT_ENDER].join("")
      end

      private

      attr_reader :statements, :params
    end
  end
end
