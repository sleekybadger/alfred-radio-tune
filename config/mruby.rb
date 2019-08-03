require_relative "./environment"
require_relative "./application"

MRuby::Build.new do
  toolchain :gcc

  cc do |compiler|
    compiler.defines = ["MRB_UTF8_STRING"]

    if Environment.debug?
      compiler.defines << "MRB_DEBUG"
      compiler.defines << "MRB_ENABLE_DEBUG_HOOK"
    end
  end

  if Environment.debug?
    enable_debug
    enable_test
    enable_bintest
  end

  gembox Application.gembox
end
