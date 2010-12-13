-module(genstore).
-vsn("1.0.0").
-author('Sergey Yelin <elinsn@gmail.com>').

-export([start/0, stop/0]).

start() ->
    application:start(genstore).
  
stop() ->
    application:stop(genstore).
  
