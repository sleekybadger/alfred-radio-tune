module RadioTune
  class ResponseRepository < BaseRepository
    ITUNES_SEARCH_URL_PATTERN = "https://itunes.apple.com/search?%".freeze

    table :cash, "cfurl_cache_response", id: "entry_ID",
                                         url: "request_key",
                                         url_hash: "hash_value"

    table :data, "cfurl_cache_receiver_data", id: "entry_ID",
                                              body: "receiver_data"

    def initialize(database_adapter)
      @database_adapter = database_adapter
    end

    def last
      row = database_adapter.execute(last_response_query.to_sql).first
      params = Response::ATTRIBUTES.zip(row).to_h

      Response.new(params.merge(body: PJSON.parse(params[:body])))
    end

    def save(response)
      database_adapter.execute(
        update_response_query(response.id, response.url, response.hash).to_sql
      )
    end

    private

    attr_reader :database_adapter

    def last_response_query
      build_query do |query|
        query.select [
          *cash_table.prefixed.values_at(:id, :url, :url_hash),
          data_table.prefixed.body
        ]

        query.from cash_table.name
        query.join data_table.name, cash_table.prefixed.id, data_table.prefixed.id
        query.like cash_table.prefixed.url, ITUNES_SEARCH_URL_PATTERN

        query.order_by cash_table.prefixed.id, :desc
        query.limit 1
      end
    end

    def update_response_query(id, url, hash)
      build_query do |query|
        query.update cash_table.name
        query.set [cash_table.url, url], [cash_table.url_hash, hash]
        query.where cash_table.id, id
      end
    end
  end
end
