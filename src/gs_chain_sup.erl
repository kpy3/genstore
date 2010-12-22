-module(gs_chain_sup).

-behaviour(supervisor).

-include("genstore.hrl").

-export([start_link/0,
         start_child/0
        ]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child() ->
    supervisor:start_child(?SERVER, []).

init([]) ->
    Element = {gs_chain, {gs_chain, start_link, []},
               temporary, brutal_kill, worker, [gs_chain]},
    Children = [Element],
    RestartStrategy = {simple_one_for_one, 0, 1},
    {ok, {RestartStrategy, Children}}.

%    Number = ?TMP_CHILD(gs_chain, [], worker),
%    RestartStrategy = {simple_one_for_one, 0, 1},
%    {ok, {RestartStrategy, Number}}.
%    {ok, { {one_for_one, 5, 10}, []} }.
