-module(protocol).

-include("protocol.hrl").

-export([ipv4/1, ipv4_listener/0]).

ipv4(<<Version:4, IHL:4, ToS:8, TotalLength:16,
    Identification:16, Flags:3, FragOffset:13,
    TimeToLive:8, Protocol:8, Checksum:16,
    SourceAddress:32, DestinationAddress:32,
    OptionsAndPadding:((IHL-5)*32)/bits,
    RemainingData/bytes>>
) when Version =:= 4 ->
    io:format("Received data ~p, Len: ~p~n", [RemainingData, TotalLength]),
    #ipv4{
        version = Version,
        ihl = IHL,
        tos = ToS,
        total_length = TotalLength,
        identification = Identification,
        flags = Flags,
        frag_offset = FragOffset,
        ttl = TimeToLive,
        proto = Protocol,
        cs = Checksum,
        sa = SourceAddress,
        da = DestinationAddress,
        options_and_padding = OptionsAndPadding,
        remaining_data = RemainingData
    };
ipv4(<<Version:4, _/bits>>) when Version =/= 4 ->
    io:format("Bad version: ~p~nOnly version 4 is supported~n", [Version]),
    exit("bad version");
ipv4(Error) ->
    io:format("Bad argument: ~p~n", [Error]),
    throw("bad arg").

ipv4_listener() ->
    receive
        {ipv4, From, BinData} when is_binary(BinData) ->
            From ! protocol:ipv4(BinData);
        Error ->
            io:format("Bad argument: ~p~n", [Error]),
            throw("bad arg")
    end.