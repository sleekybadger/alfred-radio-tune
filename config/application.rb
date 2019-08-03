module Application
  extend self

  VERSION = "0.1.0".freeze

  def name
    :radio_tune
  end

  def root
    @root ||= File.expand_path("#{File.dirname(__FILE__)}/..")
  end

  def gembox
    @gembox ||= "#{root}/#{name}"
  end

  def config
    @config ||= Configuration.new
  end

  def configure
    yield config
  end

  def database
    @database ||= config.database.tap do |db|
      raise ArgumentError, "missing --db argument" if db.empty?
      raise ArgumentError, "#{db} doesn't exists" unless File.exist?(db)
    end
  end
end
