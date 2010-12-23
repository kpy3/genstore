-module(gs_event).

-export([start_link/0,
         add_handler/2,
         delete_handler/2,
         store_chains/1,
         chains_stored/1,
         cache_deleted/1]).

-define(SERVER, ?MODULE).

start_link() ->
    gen_event:start_link({local, ?SERVER}).

add_handler(Handler, Args) ->
    gen_event:add_handler(?SERVER, Handler, Args).

delete_handler(Handler, Args) ->
    gen_event:delete_handler(?SERVER, Handler, Args).

store_chains(Cache) ->
    gen_event:notify(?SERVER, {store_chains, Cache}).

chains_stored(Cache) ->
    gen_event:notify(?SERVER, {chains_stored, Cache}).

cache_deleted(Cache) ->
    gen_event:notify(?SERVER, {cache_deleted, Cache}).
