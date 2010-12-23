-module(gs_event_logger).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

-behaviour(gen_event).

-export([add_handler/0, delete_handler/0, log_msg/2]).

-export([init/1, handle_event/2, handle_call/2,
         handle_info/2, code_change/3, terminate/2]).

-record(state, {}).

add_handler() ->
    gs_event:add_handler(?MODULE, []).

delete_handler() ->
    gs_event:delete_handler(?MODULE, []).

init([]) ->
    {ok, #state{}}.

handle_event({store_chains, Cache}, State) ->
    ?MODULE:log_msg("Store chains from cache ~p~n", [Cache]),
    {ok, State};
handle_event({chains_stored, Cache}, State) ->
    ?MODULE:log_msg("Chains stored from cache ~p~n", [Cache]),
    {ok, State};
handle_event({cache_deleted, Cache}, State) ->
    ?MODULE:log_msg("Cache ~p has been deleted~n", [Cache]),
    {ok, State}.

log_msg(Msg, Options) ->
    Message = io_lib:format(Msg, Options),
    error_logger:info_msg(Message).

handle_call(_Request, State) ->
    Reply = ok,
    {ok, Reply, State}.

handle_info(_Info, State) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
