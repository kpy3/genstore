-module(gs_number).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

-behaviour(gen_server).

-export([start_link/0, insert/1, init_cache/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(TIMEOUT, 1000). % 1 second

-record(state, {timeout, cache}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

insert(N) ->
    gen_server:cast(erlang:whereis(?SERVER),{insert, N}).

init([]) ->
    {ok, Timeout} = application:get_env(timeout),
    {ok, Cache} = ?MODULE:init_cache(),
    {ok, #state{timeout = Timeout, cache = Cache}, ?TIMEOUT}.

init_cache() ->
%    Now = calendar:local_time(),
%    CacheId = calendar:datetime_to_gregorian_seconds(Now),
    CacheName = ?SERVER,   
    Cache = ets:new(CacheName, [private, ordered_set]),
    {ok, Cache}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State, ?TIMEOUT}.

handle_cast({insert, N}, State) ->
    Cache = State#state.cache,
    Cache:insert(N),
    {noreply, State, ?TIMEOUT};
handle_cast(_Msg, State) ->
    {noreply, State, ?TIMEOUT}.

handle_info(_Info, State) ->
    {noreply, State, ?TIMEOUT}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State, ?TIMEOUT}.
