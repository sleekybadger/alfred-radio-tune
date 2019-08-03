module RadioTune
  class TestDetectCommand < MTest::Unit::TestCase
    def test_call_returns_last_radio_song
      with_database do
        command = DetectCommand.new
        composition = command.call

        assert composition, "Black Flag - TV Party"
      end
    end
  end
end
