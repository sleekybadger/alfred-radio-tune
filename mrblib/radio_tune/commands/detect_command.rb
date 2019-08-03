module RadioTune
  class DetectCommand < BaseCommand
    FAILURE_MESSAGE = "Doh! We didn't quite catch that.".freeze

    def call
      return FAILURE_MESSAGE unless response.successful?

      response_repository.save(response.update) unless response.updated?
      response.composition
    rescue StandardError => exception
      exception.message
    ensure
      database_adapter.close
    end

    private

    def response
      @response ||= response_repository.last
    end

    def response_repository
      @response_repository ||= ResponseRepository.new(database_adapter)
    end

    def database_adapter
      @database_adapter ||= DatabaseAdapter.new(Application.database)
    end
  end
end
