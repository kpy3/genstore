#!/bin/sh

export ERL_LIBS=deps
export ERL_OPTS="+K true +A 10 +P 134217727 -smp auto"

erl $ERL_OPTS -pa ./ebin -boot start_sasl -config ./config/dev.config -s genstore
