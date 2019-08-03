module RadioTune
  extend self

  def detect
    puts DetectCommand.call
  end
end

RadioTune.detect
