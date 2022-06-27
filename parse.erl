#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname factorial -mnesia debug verbose

-define(DEBUG(X,Y) , io:format(X++"~p~n", [Y])).
-define(DEBUG(X) , io:format(X)).


parse(File)->
	{ok, BinData} = file:read_file(File),
	Result = read(BinData),
	[ print(X) || X <- lists:reverse(Result)],
	ok.

print({_Tag, char, Value}) ->
	io:format("~p~n", [Value]);

print({_Tag, short, Value}) ->
	io:format("~p~n", [Value]);

print({_Tag, int32, Value}) ->
	io:format("~p~n", [Value]);

print({_Tag, int64, Value}) ->
	io:format("~p~n", [Value]);

print({_Tag, 'float', Value}) ->
	io:format("~p~n", [Value]);

print({_Tag, 'double', Value}) ->
	io:format("~p~n", [Value]);

print({_Tag, string1, Value}) ->
	io:format("~s~n", [Value]);

print({_Tag, string4, Value}) ->
	io:format("~s~n", [Value]);

print({_Tag, map, _Value}) ->
	%io:format("{~p~n", [Value]);
	io:format("{~n");

print({_Tag, map_end, _Value}) ->
	io:format("}~n");

print({_Tag, 'list', _Value}) ->
	io:format("[~n");

print({_Tag, 'list_end', _Value}) ->
	io:format("]~n");


print({_Tag, struct_begin, _Value}) ->
	io:format("(~n");

print({_Tag, struct_end, _Value}) ->
	io:format(")~n");

print({_Tag, zero, _Value}) ->
	io:format("zero~n");

print({_Tag, simple_list, Value}) ->
	io:format("<~n"),
	[ print(X) || X <- lists:reverse(Value)],
	io:format(">~n");

print(X) ->
	io:format("~p~n", [X]).




%main([]) ->
%	try
%		parse()
%	catch
%		_a:_b ->
%			io:format("~p \t ~p", [_a, _b]),
%			usage()
%	end;
main([File]) ->
	parse(File);

main(_) ->
    usage().

usage() ->
	?DEBUG("useage: parse movie.result\n"),
    halt(1).


readChar(Tag, Bin, Result, CurrentStruct) ->
	<<Data:8, Rest/binary>> = Bin,
	NewResult = [{Tag, char, Data}|Result],
	case CurrentStruct of
		[] -> read(Rest, NewResult, CurrentStruct);
		_ ->
			[CH | CT] = CurrentStruct,
			case CH of
				{'map', 1} ->
					read(Rest, [{0, map_end, <<>>} | NewResult], CT);
				{'list', 1} ->
					read(Rest, [{0, list_end, <<>>} | NewResult], CT);
				{'map', Count} ->
					read(Rest, NewResult, [{'map', Count-1} | CT]);
				{'list', Count} ->
					read(Rest, NewResult, [{'list', Count-1} | CT]);
				_ ->
					read(Rest, NewResult, CurrentStruct)
			end
	end.


readShort(Tag, Bin, Result, CurrentStruct) ->
	<<Data:16, Rest/binary>> = Bin,
	NewResult = [{Tag, short, Data}|Result],
	case CurrentStruct of
		[] -> read(Rest, NewResult, CurrentStruct);
		_ ->
			[CH | CT] = CurrentStruct,
			case CH of
				{'map', 1} ->
					read(Rest, [{0, map_end, <<>>} | NewResult], CT);
				{'list', 1} ->
					read(Rest, [{0, list_end, <<>>} | NewResult], CT);
				{'map', Count} ->
					read(Rest, NewResult, [{'map', Count-1} | CT]);
				{'list', Count} ->
					read(Rest, NewResult, [{'list', Count-1} | CT]);
				_ ->
					read(Rest, NewResult, CurrentStruct)
			end
	end.


readInt32(Tag, Bin, Result, CurrentStruct) ->
	<<Data:32, Rest/binary>> = Bin,
	NewResult = [{Tag, int32, Data}|Result],
	case CurrentStruct of
		[] -> read(Rest, NewResult, CurrentStruct);
		_ ->
			[CH | CT] = CurrentStruct,
			case CH of
				{'map', 1} ->
					read(Rest, [{0, map_end, <<>>} | NewResult], CT);
				{'list', 1} ->
					read(Rest, [{0, list_end, <<>>} | NewResult], CT);
				{'map', Count} ->
					read(Rest, NewResult, [{'map', Count-1} | CT]);
				{'list', Count} ->
					read(Rest, NewResult, [{'list', Count-1} | CT]);
				_ ->
					read(Rest, NewResult, CurrentStruct)
			end
	end.


readInt64(Tag, Bin, Result, CurrentStruct) ->
	<<Data:64, Rest/binary>> = Bin,
	NewResult = [{Tag, int64, Data}|Result],
	case CurrentStruct of
		[] -> read(Rest, NewResult, CurrentStruct);
		_ ->
			[CH | CT] = CurrentStruct,
			case CH of
				{'map', 1} ->
					read(Rest, [{0, map_end, <<>>} | NewResult], CT);
				{'list', 1} ->
					read(Rest, [{0, list_end, <<>>} | NewResult], CT);
				{'map', Count} ->
					read(Rest, NewResult, [{'map', Count-1} | CT]);
				{'list', Count} ->
					read(Rest, NewResult, [{'list', Count-1} | CT]);
				_ ->
					read(Rest, NewResult, CurrentStruct)
			end
	end.



readFloat(Tag, Bin, Result, CurrentStruct) ->
	%io:format("~n--------------------~p=============~n", [CurrentStruct]),
	<<Data:32, Rest/binary>> = Bin,
	NewResult = [{Tag, 'float', Data}|Result],
	case CurrentStruct of
		[] -> read(Rest, NewResult, CurrentStruct);
		_ ->
			[CH | CT] = CurrentStruct,
			case CH of
				{'map', 1} ->
					read(Rest, [{0, map_end, <<>>} | NewResult], CT);
				{'list', 1} ->
					read(Rest, [{0, list_end, <<>>} | NewResult], CT);
				{'map', Count} ->
					read(Rest, NewResult, [{'map', Count-1} | CT]);
				{'list', Count} ->
					read(Rest, NewResult, [{'list', Count-1} | CT]);
				_ ->
					read(Rest, NewResult, CurrentStruct)
			end
	end.



readDouble(Tag, Bin, Result, CurrentStruct) ->
	<<Data:64, Rest/binary>> = Bin,
	NewResult = [{Tag, 'double', Data}|Result],
	case CurrentStruct of
		[] -> read(Rest, NewResult, CurrentStruct);
		_ ->
			[CH | CT] = CurrentStruct,
			case CH of
				{'map', 1} ->
					read(Rest, [{0, map_end, <<>>} | NewResult], CT);
				{'list', 1} ->
					read(Rest, [{0, list_end, <<>>} | NewResult], CT);
				{'map', Count} ->
					read(Rest, NewResult, [{'map', Count-1} | CT]);
				{'list', Count} ->
					read(Rest, NewResult, [{'list', Count-1} | CT]);
				_ ->
					read(Rest, NewResult, CurrentStruct)
			end
	end.


readString1(Tag, Bin, Result, CurrentStruct) ->
	<<Length:8, Rest/binary>> = Bin,
	%io:format("string1 length: ~p ---------~n", [Length]),
	%length需要是整形
	{Rest_, NewResult_} = case Length > 0 of
		true -> <<Data:Length/bytes, Rest1/binary>> = Rest,
				%io:format("<< string1 data: ~s >>\n", [Data]),
				NewResult = [{Tag, 'string1', Data}|Result],
				{Rest1, NewResult};
		false -> NewResult = [{Tag, 'string1', <<"">>}|Result],
				 %io:format("<< string1 data: nill >>\n"),
				 {Rest, NewResult}
	end,
	%io:format("~n=============~p=============~n", [CurrentStruct]),
	case CurrentStruct of
		[] ->
			read(Rest_, NewResult_, CurrentStruct);
		_  ->
			[CH | CT] = CurrentStruct,
			case CH of
				{'map', 1} ->
					read(Rest_, [{0, map_end, <<>>} | NewResult_], CT);
				{'list', 1} ->
					read(Rest_, [{0, list_end, <<>>} | NewResult_], CT);
				{'map', Count} ->
					read(Rest_, NewResult_, [{'map', Count-1} | CT]);
				{'list', Count} ->
					read(Rest_, NewResult_, [{'list', Count-1} | CT]);
				_ ->
					read(Rest_, NewResult_, CurrentStruct)
			end

	end.


readString4(Tag, Bin, Result, CurrentStruct) ->
	<<Length:32, Rest/binary>> = Bin,
	%length需要是整形
	<<Data:Length/bytes, Rest1/binary>> = Rest,
	NewResult = [{Tag, 'string4', Data}|Result],
	[CH | CT] = CurrentStruct,
	case CH of
		{'map', 1} ->
			read(Rest1, [{0, map_end, <<>>} | NewResult], CT);
		{'list', 1} ->
			read(Rest1, [{0, list_end, <<>>} | NewResult], CT);
		{'map', Count} ->
			read(Rest1, NewResult, [{'map', Count-1} | CT]);
		{'list', Count} ->
			read(Rest1, NewResult, [{'list', Count-1} | CT]);
		_ ->
			read(Rest1, NewResult, CurrentStruct)
	end.



readMap(Tag, Bin, Result, CurrentStruct) ->
	%map 的 count 有 4 种情况:
	%1. 长度在-128->127 之间且大于 0是先写了个 char 的 header 然后跟着一个字节的长度
	%2. 如何 length=0, 那么写入的是一个 zero, 无 body
	%3. 如果大小在-32768->32768 之间, 则是写入了一个 short int 类型的长度
	%4. 不在 32768 之间的, 写入了一个 int32 类型的长度
	<<_HeadTag:4, CountType:4, Rest/binary>> = Bin,
	case CountType of
		0 -> <<Count:8, Rest1/binary>> = Rest;		%char 类型的长度
		12 -> Count = 0, Rest1 = Rest;		    	%Zero 类型无长度
		1 -> <<Count:16, Rest1/binary>> = Rest;		%Short 类型的长度
		2 -> <<Count:32, Rest1/binary>> = Rest;		%Int32 类型的长度
		_T -> Count = 0, Rest1 = Rest, io:format("error: get map count wrong!!!!!!!!, countType: ~p~n", [_T])
	end,
	%count需要是整形
	case Count of
		0 ->
			NewResult = [{0, 'map_end', <<>>}, {Tag, 'map', Count} | Result],
			NewCurrentStruct = CurrentStruct;
		_ ->
			NewResult = [{Tag, 'map', Count} | Result],
			NewCurrentStruct = [{'map', Count*2} | CurrentStruct]
	end,
	%io:format("<< map count : ~p>>\n", [Count]),
	read(Rest1, NewResult, NewCurrentStruct).


readList(Tag, Bin, Result, CurrentStruct) ->
	% list 的个数和 map 的个数取法一致:
	<<_HeadTag:4, CountType:4, Rest/binary>> = Bin,
	case CountType of
		0 -> <<Count:8, Rest1/binary>> = Rest;		%char 类型的长度
		12 -> Count = 0, Rest1 = Rest;		    	%Zero 类型无长度
		1 -> <<Count:16, Rest1/binary>> = Rest;		%Short 类型的长度
		2 -> <<Count:32, Rest1/binary>> = Rest;		%Int32 类型的长度
		_T -> Count = 0, Rest1 = Rest, io:format("error: get list count wrong!!!!!!!!, countType: ~p~n", [_T])
	end,
	%count需要是整形
	case Count of
		0 ->
			NewResult = [{0, 'list_end', <<>>}, {Tag, 'list', Count} | Result],
			NewCurrentStruct = CurrentStruct;
		_ ->
			NewResult = [{Tag, 'list', Count} | Result],
			NewCurrentStruct = [{'list', Count} | CurrentStruct]
	end,
	%io:format("<< List count : ~p>>\n", [Count]),
	read(Rest1, NewResult, NewCurrentStruct).

readStructBegin(Tag, Bin, Result, CurrentStruct) ->
	NewResult = [{Tag, 'struct_begin', <<>>} | Result],
	NewCurrentStruct = [{'struct_begin', <<>>} | CurrentStruct],
	read(Bin, NewResult, NewCurrentStruct).

readStructEnd(Tag, Bin, Result, CurrentStruct) ->
	%io:format("~n=============~p=============~n", [CurrentStruct]),
	Rest = Bin,
	NewResult = [{Tag, 'struct_end', <<>>} | Result],
	[CH1 | CT] = CurrentStruct,
	case CH1 of
		{struct_begin, _} ->
			[CH2 | CT2] = case CT of
				[] -> [[], []];
				_  -> CT
			end,
			case CH2 of
					{'map', 1} ->
						read(Rest, [{0, map_end, <<>>} | NewResult], CT2);
					{'list', 1} ->
						read(Rest, [{0, list_end, <<>>} | NewResult], CT2);
					{'map', Count} ->
						read(Rest, NewResult, [{'map', Count-1} | CT2]);
					{'list', Count} ->
						read(Rest, NewResult, [{'list', Count-1} | CT2]);
					_ ->
						read(Rest, NewResult, CT)
				end;
		_Other -> io:format("struct_end dose not match struct_begin: ~p~n", [_Other])
	end.

readZero(Tag, Bin, Result, CurrentStruct) ->
	NewResult = [{Tag, 'zero', <<>>} | Result],
	Rest = Bin,
	case CurrentStruct of
		[] -> read(Rest, NewResult, CurrentStruct);
		_ ->
			[CH | CT] = CurrentStruct,
			case CH of
				{'map', 1} ->
					read(Rest, [{0, map_end, <<>>} | NewResult], CT);
				{'list', 1} ->
					read(Rest, [{0, list_end, <<>>} | NewResult], CT);
				{'map', Count} ->
					read(Rest, NewResult, [{'map', Count-1} | CT]);
				{'list', Count} ->
					read(Rest, NewResult, [{'list', Count-1} | CT]);
				_ ->
					read(Rest, NewResult, CurrentStruct)
			end
	end.

readSimpleList(Tag, Bin, Result, CurrentStruct) ->
	% simplelist的长度和 map 的个数取法一致:
	% 从 c++源码上看 simplelist 的 长度必须是 char 类型的 head, 后面紧跟长度的 head
	<<_B1:4, _B2:4, _HeadTag:4, CountType:4, Rest/binary>> = Bin,
	case CountType of
		0 -> <<Count:8, Rest1/binary>> = Rest;		%char 类型的长度
		12 -> Count = 0, Rest1 = Rest;		    	%Zero 类型无长度
		1 -> <<Count:16, Rest1/binary>> = Rest;		%Short 类型的长度
		2 -> <<Count:32, Rest1/binary>> = Rest;		%Int32 类型的长度
		_T -> Count = 0, Rest1 = Rest, io:format("error: get list count wrong!!!!!!!!, countType: ~p~n", [_T])
	end,
	%count=length需要是整形
	<<Data:Count/bytes, Rest2/binary>> = Rest1,
	%NewResult = [{Tag, 'simple_list', Data} | Result],
	%io:format("smiplelist1 length: ~p \t data :+++++~n~s~n=========~n", [Count, Data]),
	SimpleList1 = try read(Data) of
		SimpleList -> [ X || X <- SimpleList]
	catch _A:_B ->
		SimpleList = <<"read simple list with exception">>,
		[{0, 'string1', SimpleList}]
	end,

	%io:format("smiplelist1++++++++~n~p~n=========~n", [SimpleList1]),
	%[ print(Y) || Y <- lists:reverse(SimpleList)],
	%io:format("========= simpleList  end =============~n"),
	NewResult = [{Tag, 'simple_list', SimpleList1} | Result],
	%io:format("currentstruct++++++++~n~p~n=========~n", [CurrentStruct]),
	[CH | CT] = CurrentStruct,
	case CH of
		{'map', 1} ->
			read(Rest2, [{0, map_end, <<>>} | NewResult], CT);
		{'list', 1} ->
			read(Rest2, [{0, list_end, <<>>} | NewResult], CT);
		{'map', Count} ->
			read(Rest2, NewResult, [{'map', Count-1} | CT]);
		{'list', Count} ->
			read(Rest2, NewResult, [{'list', Count-1} | CT]);
		_ ->
			read(Rest2, NewResult, CurrentStruct)
	end.


read(<<>>, Result, _CurrentStruct)->
	%io:format("~p", [lists:reverse(Result)]),
	Result;
read(Bin, Result, CurrentStruct) ->
	%io:format("last Result is :  ~p \t", [lists:reverse(Result)]),
	<<Tag1:4, Type:4, Rest1/binary>> = Bin,
	case Tag1 of
		15 -> <<Tag2:8, Rest2/binary>> = Rest1, Tag=Tag2, Rest = Rest2;
		_ -> Tag = Tag1, Rest = Rest1
	end,

	%io:format("----Tag: ~p, \t type: ~p ~n", [Tag, Type]),
	case Type of
		0 -> readChar(Tag, Rest, Result, CurrentStruct);
		1 -> readShort(Tag, Rest, Result, CurrentStruct);
		2 -> readInt32(Tag, Rest, Result, CurrentStruct);
		3 -> readInt64(Tag, Rest, Result, CurrentStruct);
		4 -> readFloat(Tag, Rest, Result, CurrentStruct);
		5 -> readDouble(Tag, Rest, Result, CurrentStruct);
		6 -> readString1(Tag, Rest, Result, CurrentStruct);
		7 -> readString4(Tag, Rest, Result, CurrentStruct);
		8 -> readMap(Tag, Rest, Result, CurrentStruct);
		9 -> readList(Tag, Rest, Result, CurrentStruct);
		10 -> readStructBegin(Tag, Rest, Result, CurrentStruct);
		11 -> readStructEnd(Tag, Rest, Result, CurrentStruct);
		12 -> readZero(Tag, Rest, Result, CurrentStruct);
		13 -> readSimpleList(Tag, Rest, Result, CurrentStruct)
	end.

read(Bin) ->
	read(Bin, [], []).
