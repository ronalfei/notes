-module(mkdir).
-compile(export_all).
run(N) -> 
	PREFIX="/opt/test/bee/upload",
	M = N,
	L = lists:seq(0, M),
	F = fun(X) ->
			Xstr= io_lib:format("~3.3.0s", [integer_to_list(X)]),
			%io:format("Xstring is \"~s\"~n", [Xstr]),
			%spawn(fun() ->
			lists:map(fun(Y) ->
						Ystr= io_lib:format("~3.3.0s", [integer_to_list(Y)]),
						%io:format("Ystring is \"~s\"~n", [Ystr]),
						Cmd = io_lib:format("mkdir -p ~s/~s/~s/", [PREFIX, Xstr, Ystr]),
						io:format("~s ~n", [Cmd]),
						os:cmd(Cmd)
						end , L)
			%		end)
		end,
	lists:map(F, L),
	ok.
