module RadioTune
  class TestResponseEntity < MTest::Unit::TestCase
    def test_composition_with_response_body
      info = Hash["artistName", "Leonard Cohen", "trackName", "Treatyj"]
      body = Hash["results", [info]]
      response = Response.new(id: 1, url: "https://example.com", hash: "4189983861", body: body)

      assert response.composition, "Leonard Cohen - Treaty"
    end

    def test_composition_without_response_body
      url = "https://example.com?term=Leonard%20Cohen%20-%20Treaty"
      body = Hash["results", []]
      response = Response.new(id: 1, url: url, hash: "4189983861", body: body)

      assert response.composition, "Leonard Cohen - Treaty"
    end

    def test_successful_with_composition
      info = Hash["artistName", "Leonard Cohen", "trackName", "Treatyj"]
      body = Hash["results", [info]]
      response = Response.new(id: 1, url: "https://example.com", hash: "4189983861", body: body)

      assert response.successful?
    end

    def test_successful_without_composition
      body = Hash["results", []]
      response = Response.new(id: 1, url: "https://example.com", hash: "4189983861", body: body)

      assert_false response.successful?
    end

    def test_updated_with_signed_url
      url = "https://example.com?tr_updated_at=1001240214"
      response = Response.new(id: 1, url: url, hash: "4189983861", body: {})

      assert response.updated?
    end

    def test_updated_without_signed_url
      url = "https://example.com"
      response = Response.new(id: 1, url: url, hash: "4189983861", body: {})

      assert_false response.updated?
    end

    def test_update_return_new_response
      url = "https://example.com"
      response = Response.new(id: 1, url: url, hash: "4189983861", body: {})
      updated_response = response.update

      assert_match updated_response.url, /tr_updated_at/
    end
  end
end
