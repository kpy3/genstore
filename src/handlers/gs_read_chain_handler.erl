-module(gs_read_chain_handler).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

% Public API
-export([handle_request/1]).

%% callback on request received
handle_request(Req) ->
    Req:respond({200, [], <<"Hello, GET!\r\n">>}).

    