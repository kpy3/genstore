-module(gs_chain).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

-behaviour(gen_server).

-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(TIMEOUT(T), T * 1000).

-record(state, {timeout}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    {ok, Timeout} = application:get_env(timeout),
    {ok, #state{timeout = Timeout}, ?TIMEOUT(Timeout)}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    Timeout = State#state.timeout,
    {reply, Reply, State, ?TIMEOUT(Timeout)}.

handle_cast(_Msg, State) ->
    Timeout = State#state.timeout,
    {noreply, State, ?TIMEOUT(Timeout)}.

handle_info(_Info, State) ->
    Now = iso_8601_fmt(erlang:localtime()),
    io:format(<<"===> [~s] timeout!~n">>, [Now]),
    Timeout = State#state.timeout,
    {noreply, State, ?TIMEOUT(Timeout)}.

iso_8601_fmt(DateTime) ->
    {{Year,Month,Day},{Hour,Min,Sec}} = DateTime,
    io_lib:format("~4.10.0B-~2.10.0B-~2.10.0B ~2.10.0B:~2.10.0B:~2.10.0B",
        [Year, Month, Day, Hour, Min, Sec]).

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    Timeout = State#state.timeout,
    {ok, State, ?TIMEOUT(Timeout)}.
