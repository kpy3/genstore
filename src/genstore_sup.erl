
-module(genstore_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Options, Type), {I, {I, start_link, [Options]}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, MisultinConfig} = misultin_config(),
    Http = ?CHILD(misultin, MisultinConfig, worker),
    {ok, { {one_for_one, 5, 10}, [Http]} }.

misultin_config() ->
    {ok, Config} = application:get_env(misultin),
    {value, {handler, Module, Function}} = lists:keysearch(handler, 1, Config), 
    Config1 = Config ++ [{loop, fun(Req) -> erlang:apply(Module, Function, [Req]) end}],
    {ok, Config1}.
