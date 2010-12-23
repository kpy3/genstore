-module(gs_app).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, Config} = application:get_env(mochiweb),
    mochiweb_http:start(Config),
    gs_store:init(),
    case gs_sup:start_link() of
        {ok, Pid} ->
            gs_event_logger:add_handler(),
            {ok, Pid};
        Other ->
            {error, Other}
    end.

stop(_State) ->
    mochiweb_http:stop(),
    ok.
