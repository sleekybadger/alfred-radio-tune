module Environment
  extend self

  DEVELOPMENT = "development".freeze
  TEST = "test".freeze
  PRODUCTION = "production".freeze

  def development?
    env == DEVELOPMENT
  end

  def test?
    env == TEST
  end

  def production?
    env == PRODUCTION
  end

  def debug?
    development? || test?
  end

  alias dev? development?
  alias prod? production?

  private

  def env
    @env ||= ENV.fetch("MRB_ENV", DEVELOPMENT)
  end
end
