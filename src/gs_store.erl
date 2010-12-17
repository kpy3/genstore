-module(gs_store).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

-export([
         init/0,
         insert/1,
         chains/1
        ]).

-define(STORE_ID, ?MODULE).

init() ->
    ets:new(?STORE_ID, [public, named_table, ordered_set, {write_concurrency, true}]),
    ok.

insert(N) when is_integer(N) ->
    ets:insert(?STORE_ID, {N}).

chains(N) when is_integer(N) ->
   {ok, N}.

