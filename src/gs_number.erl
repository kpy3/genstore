-module(gs_number).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

-behaviour(gen_server).

-export([start_link/0, insert/1, init_cache/0, store_chains/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(TIMEOUT, 1000). % 1 second

-record(state, {last_access, timeout, cache}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

insert(N) ->
    gen_server:cast(erlang:whereis(?SERVER),{insert, N}).

init([]) ->
    {ok, Timeout} = application:get_env(timeout),
    Now = calendar:local_time(),
    LastAccess = calendar:datetime_to_gregorian_seconds(Now),
    {ok, Cache} = ?MODULE:init_cache(),
    {ok, #state{last_access = LastAccess, timeout = Timeout, cache = Cache}, ?TIMEOUT}.

init_cache() ->
    Cache = ets:new(?MODULE, [public, ordered_set]),
    {ok, Cache}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State, ?TIMEOUT}.

handle_cast({insert, N}, #state{timeout = Timeout, cache = Cache} = _State) ->
    Cache:insert(N),
    Now = calendar:local_time(),
    NowTime = calendar:datetime_to_gregorian_seconds(Now),
    {noreply, #state{last_access = NowTime, timeout = Timeout, cache = Cache}, ?TIMEOUT};
handle_cast(_Msg, State) ->
    {noreply, State, ?TIMEOUT}.

handle_info({chains_stored, Cache}, State) ->
    io:format("===> Chains stored from ~p~n", [Cache]),
    ets:delete(Cache),
    {noreply, State, ?TIMEOUT};
handle_info(_Info,  #state{
                        last_access = LastAccess,
                        timeout = Timeout,
                        cache = Cache
                     } = State) ->
    Now = calendar:local_time(),
    NowTime = calendar:datetime_to_gregorian_seconds(Now),
    case NowTime - LastAccess of
        T when T >= Timeout -> 
            ?MODULE:store_chains(Cache),
            {ok, NewCache} = ?MODULE:init_cache(), 
            {noreply, #state{last_access = NowTime, timeout = Timeout, cache = NewCache}, ?TIMEOUT};
        _ ->
            {noreply, State, ?TIMEOUT}
    end.

store_chains(Cache) ->
    {ok, Pid} = gs_chain_sup:start_child(),
    Pid ! {store_chains, Cache}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State, ?TIMEOUT}.
