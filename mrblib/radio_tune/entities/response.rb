module RadioTune
  class Response
    ATTRIBUTES = %i[id url hash body].freeze

    UPDATED_AT_LABEL = "tr_updated_at".freeze
    UPDATED_AT_REG_EXP = /#{UPDATED_AT_LABEL}=(\d+)$/.freeze
    COMPOSITION_REG_EXP = /term=(.+)&?$/.freeze

    attr_reader :id, :url, :hash, :body

    def initialize(id:, url:, hash:, body:)
      @id = id
      @url = url
      @hash = hash
      @body = body
    end

    def composition
      @composition ||= empty_body? ? parse_url : parse_body
    end

    def update
      next_url = "#{url}&#{updated_at_param}"
      next_hash = next_url.hash

      self.class.new(id: id, url: next_url, hash: next_hash, body: body)
    end

    def updated?
      !!UPDATED_AT_REG_EXP.match(url)
    end

    def successful?
      !composition.nil?
    end

    private

    def empty_body?
      body["results"].empty?
    end

    def parse_url
      matches = COMPOSITION_REG_EXP.match(url)
      return nil unless matches

      URI.decode(matches.captures.first)
    end

    def parse_body
      body["results"].first.values_at("artistName", "trackName").join(" - ")
    end

    def updated_at_param
      "#{UPDATED_AT_LABEL}=#{Time.now.to_i}"
    end
  end
end
