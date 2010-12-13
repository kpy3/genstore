ERL ?= erl
APP := genstore

.PHONY: deps

all: deps
	@./rebar compile

deps:
	@./rebar get-deps

clean:
	@./rebar clean

distclean: clean
	@./rebar delete-deps
	@rm -rf rel/myfinmain
	@rm -f erl_crash.dump

docs:
	@erl -noshell -run edoc_run application '$(APP)' '"."' '[]'

release: all
	@./rebar generate
