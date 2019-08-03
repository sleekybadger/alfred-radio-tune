class Configuration
  attr_accessor :database

  def initialize
    @database = options.fetch(:db)
  end

  private

  def options
    @options ||= Getopts.getopts(nil, "db:").transform_keys(&:to_sym)
  end
end
