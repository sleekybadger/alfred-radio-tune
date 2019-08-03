module RadioTune
  class TestDatabaseAdapter < MTest::Unit::TestCase
    def test_execute_returns_result_of_sql_query
      with_database do
        database_adapter = DatabaseAdapter.new(Application.database)
        result = database_adapter.execute %{
          SELECT * from dummy ORDER BY id DESC;
        }

        assert result.first, [1, "Sheena Is a Punk Rocker"]
        assert result.last, [2, "The KKK Took My Baby Away"]
      end
    end
  end
end
