Tempfile.new([Application.name.to_s, ".sqlite"]).tap do |database|
  Application.config.database = database.path

  begin
    MTest::Unit.new.run
  ensure
    database.close
    database.unlink
  end
end
