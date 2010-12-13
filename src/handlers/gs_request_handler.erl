-module(gs_request_handler).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

% API
-export([handle_request/1]).

%% callback on request received
handle_request(Req) ->
    Req:ok(<<"Hello, World!">>).

% ---------------------------- /\ handle rest --------------------------------------------------------------

