module RadioTune
  class TestResponseRepository < MTest::Unit::TestCase
    def setup
      @database_adapter = database_adapter_stub(response_rows)
      @repository = ResponseRepository.new(@database_adapter)
    end

    def test_last
      @repository.last

      expectation = %{
        SELECT cfurl_cache_response.entry_ID,
               cfurl_cache_response.request_key,
               cfurl_cache_response.hash_value,
               cfurl_cache_receiver_data.receiver_data
        FROM cfurl_cache_response
        INNER JOIN cfurl_cache_receiver_data
        ON cfurl_cache_response.entry_ID = cfurl_cache_receiver_data.entry_ID
        WHERE cfurl_cache_response.request_key
        LIKE 'https://itunes.apple.com/search?%'
        ORDER BY cfurl_cache_response.entry_ID desc
        LIMIT 1;
      }

      assert expectation, @database_adapter.last_query
    end

    def test_save
      @repository.save Response.new(response_attributes)

      expectation = %{
        UPDATE cfurl_cache_response
        SET request_key = 'https://example.com', hash_value = '4189983861'
        WHERE entry_ID = '1';
      }

      assert expectation, @database_adapter.last_query
    end

    private

    def response_attributes
      {
        id: "1",
        url: "https://example.com",
        hash: "4189983861",
        body: "{}"
      }
    end

    def response_rows
      [response_attributes.values_at(:id, :url, :hash, :body)]
    end
  end
end
