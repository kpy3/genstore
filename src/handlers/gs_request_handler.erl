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
%    Req:ok(<<"Hello, World!">>).

% ---------------------------- /\ handle rest --------------------------------------------------------------

% Handle creates
handle('PUT', Req) ->
    gs_create_chain_handler:handle_request(Req);
% Handle reads
handle('GET', Req) ->
    gs_read_chain_handler:handle_request(Req);
% Handle updates
handle('POST', Req) ->
    gs_update_chain_handler:handle_request(Req);
% Handle deletes
handle('DELETE', Req) ->
    gs_delete_chain_handler:handle_request(Req);
handle(_, Req) ->
    Req:respond(405, <<"Method not allowed\n">>).
    