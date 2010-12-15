-module(genstore_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, Config} = application:get_env(mochiweb),
    mochiweb_http:start(Config),
    genstore_sup:start_link().

stop(_State) ->
    mochiweb_http:stop(),
    ok.
