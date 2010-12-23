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
            Req:respond({200, [], "Wrong input, must be a number!\r\n"})
    end.

insert(N) ->
    try list_to_integer(binary_to_list(N)) of
        Num -> 
            gs_number:insert(Num)
    catch 
        _:_ -> 
            error
    end.
        