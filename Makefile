ifeq ($(MAKECMDGOALS), release)
  MRB_ENV ?= production
else ifeq ($(MAKECMDGOALS), test)
  MRB_ENV ?= test
else
  MRB_ENV ?= development
endif

ifneq ($(MRB_ENV), production)
	DEBUG_LEVEL = "-g"
endif

MRBC = mruby/bin/mrbc
MRBCFLAGS = -B bytecode
MRUBY_CONFIG = ../config/mruby.rb

ENTRYPOINT = src/main.c

CONFIG = config/environment.rb config/configuration.rb config/application.rb
APP = $(wildcard mrblib/radio_tune/**/*.rb)
TEST = $(wildcard test/**/*.rb)

ifneq ($(MRB_ENV), test)
	BIN = build/bin/radio-tune
	SRC = $(CONFIG) $(APP) mrblib/radio_tune.rb
else
	BIN = build/bin/radio-tune-test
	SRC = $(CONFIG) $(APP) $(TEST) test/test_helper.rb
endif

CC = gcc
CCFLAGS = -Wall
CPPFLAGS = -Ibuild -Imruby/include -DMRB_ENV=\"$(MRB_ENV)\"

LDFLAGS = -Lmruby/build/host/lib
LDLIBS = -lmruby

.PHONY: all clean clean_build test release

all: clean_build build $(BIN)

clean_build:
	rm -rf build

clean: clean_build
	cd mruby && make clean

test: clean_build build $(BIN)

release: clean build releases $(BIN)
	scripts/release

build:
	mkdir -p build/bin

releases:
	mkdir -p releases

$(BIN): build/main.o
	$(CC) -o $@ $(LDFLAGS) $(LDLIBS) $<

build/main.o: build/bytecode.c
	$(CC) -c -o $@ $(CCFLAGS) $(CPPFLAGS) $(ENTRYPOINT)

build/bytecode.c: $(MRBC)
	$(MRBC) -o $@ $(DEBUG_LEVEL) $(MRBCFLAGS) $(SRC)

$(MRBC):
	unset CC CCFLAGS CPPFLAGS LDFLAGS LDLIBS && \
	cd mruby && make MRB_ENV=$(MRB_ENV) MRUBY_CONFIG=$(MRUBY_CONFIG)
