-module(gs_sup).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Options, Type), {I, {I, start_link, Options}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, Timeout} = application:get_env(timeout),
    ChainExtractor = ?CHILD(gs_chain_ext, [], worker),
    {ok, { {one_for_one, 5, 10}, [ChainExtractor]} }.
%    {ok, { {one_for_one, 5, 10}, []} }.
