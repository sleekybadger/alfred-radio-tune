module RadioTune
  module TestDatabase
    def with_database
      database = TestDatabase.new

      database.create
      database.seed

      yield database if block_given?
    ensure
      database.clear
      database.close
    end

    class TestDatabase
      def create
        connection.execute %{
          CREATE TABLE IF NOT EXISTS dummy(
            id INTEGER PRIMARY KEY,
            message TEXT
          );

          CREATE TABLE IF NOT EXISTS cfurl_cache_response(
            entry_ID INTEGER PRIMARY KEY,
            hash_value INTEGER,
            request_key TEXT UNIQUE
          );

          CREATE TABLE IF NOT EXISTS cfurl_cache_receiver_data(
            entry_ID INTEGER PRIMARY KEY,
            receiver_data BLOB
          );
        }
      end

      # rubocop:disable Metrics/LineLength
      def seed
        connection.execute %{
          INSERT INTO dummy (message) VALUES ('Sheena Is a Punk Rocker');
          INSERT INTO dummy (message) VALUES ('The KKK Took My Baby Away');

          INSERT INTO cfurl_cache_response (
            hash_value,
            request_key,
          ) VALUES (
            '334838338',
            'https://itunes.apple.com/search?media=music&term=Black%20Flag%20-%20Tv%20Party',
          );

          INSERT INTO cfurl_cache_receiver_data (
            receiver_data
          ) VALUES (
            X\'7B0A202022726573756C74436F756E74223A20312C0A202022726573756C7473223A205B0A202020207B0A202020202020226172746973744E616D65223A2022426C61636B20466C6167222C0A20202020202022747261636B4E616D65223A20225456205061727479220A202020207D0A20205D0A7D0A'
          );
        }
      end
      # rubocop:enable Metrics/LineLength

      def clear
        connection.execute %{
          DROP TABLE IF EXISTS dummy;
          DROP TABLE IF EXISTS cfurl_cache_response;
          DROP TABLE IF EXISTS cfurl_cache_receiver_data;
        }
      end

      def close
        connection.close
      end

      private

      def connection
        @connection ||= SQLite3::Database.new(Application.database)
      end
    end
  end
end

module MTest
  class Unit
    class TestCase
      include RadioTune::TestDatabase
    end
  end
end
