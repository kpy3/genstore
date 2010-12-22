-module(gs_put_handler).
-author('Sergey Yelin <elinsn@gmail.com>').
-vsn("1.0.0").

% Public API
-export([handle_request/1, insert/1]).

%% callback on request received
handle_request(Req) ->
    Data=Req:recv_body(),
    case insert(Data) of
        ok -> 
            Req:respond({201, [], "201 Created\r\n"});
        _ ->
            Req:respond({412, [], "Precondition Failed\r\n"})
    end.

insert(N) when is_integer(N) ->
    gs_chain:insert(N),
    ok;
insert(_) ->
    {error, bad_number}.
        