-module(gs_request_handler).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

% Public API
-export([handle_request/1]).

%Intenral API
-export([handle/2]).

%% callback on request received
handle_request(Req) ->
    ?MODULE:handle(Req:get(method), Req).   

% ---------------------------- /\ handle rest --------------------------------------------------------------

% Handle creates
handle('PUT', Req) ->
    gs_put_handler:handle_request(Req);
% Handle reads
handle('GET', Req) ->
    gs_get_handler:handle_request(Req);
handle(_, Req) ->
    Headers = [{"Allow", "GET,PUT"}],
    Req:respond({405, Headers, <<"405 Method Not Allowed\r\n">>}).
    