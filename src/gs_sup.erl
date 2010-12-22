-module(gs_sup).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

-behaviour(supervisor).

-include("genstore.hrl").

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    Number = ?CHILD(gs_number, [], worker),
    ChainSup = ?CHILD(gs_chain_sup, [], supervisor),
    {ok, { {one_for_one, 5, 10}, [ChainSup, Number]} }.
%    {ok, { {one_for_one, 5, 10}, []} }.
