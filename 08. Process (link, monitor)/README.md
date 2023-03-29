### Создание child процессов и тест

```
15> c("keylist_mgr.erl").
{ok,keylist_mgr}
16> keylist_mgr:start(). 
{ok,<0.159.0>,#Ref<0.2653622899.462159873.78782>}
17> self().
<0.151.0>
18> keylist_mgr ! {self(), start_child, keylist1}.
{<0.151.0>,start_child,keylist1}
19> keylist_mgr ! {self(), start_child, keylist2}.
{<0.151.0>,start_child,keylist2}
20> keylist_mgr ! {self(), start_child, keylist3}.
{<0.151.0>,start_child,keylist3}
21> erlang:send(keylist3, {self(), add, "One", "Two", "Three"}). 
{<0.151.0>,add,"One","Two","Three"}
22> flush().
Shell got [{ok,<0.162.0>}]
Shell got [{ok,<0.164.0>}]
Shell got [{ok,<0.166.0>}]
Shell got {ok,{state,[{"One","Two","Three"}],1}}
ok
23> erlang:send(keylist3, {self(), is_member, "One"}).                
{<0.151.0>,is_member,"One"}
24> flush().
Shell got {ok,true}
ok
25> self().
<0.151.0>
26> 
```

### Убийство child процесса:

```
25> self().
<0.151.0>
26> 
26> 
26> exit(whereis(keylist1), shutdown).
EXIT(<0.162.0>): shutdown
true
27> flush().
ok
28> self().
<0.151.0>
```

#### ----===/ Комментарий /===----

Pid не изменился, но к менеджеру пришло уведомление о том, что процесс умер, поскольку он с ними был связан, но с trap_exit=true

#### -------------------------



### Убийство mgr процесса:

```
4> keylist_mgr:start().
{ok,<0.99.0>,#Ref<0.3229550752.3956015107.1917>}
5> 
5> exit(whereis(keylist_mgr), kill).
true
6> flush().
Shell got {'DOWN',#Ref<0.3229550752.3956015107.1917>,process,<0.99.0>,killed}
ok
7> self().
<0.80.0>
```

#### ----===/ Комментарий /===----

Pid не изменился, нам пришло уведомление о том, что процесс умер, так как мы его мониторили

#### -------------------------

## ----===/ ВОПРОС /===----

Сначала я пытался написать функцию start/0 вот так:
`
 start() ->
     Pid = spawn(?MODULE, loop, [#state_ch{}]),
     MonitorRef = erlang:monitor(process, Pid),
     register(?MODULE, Pid),
     process_flag(trap_exit, true),
     {ok, Pid, MonitorRef}.
`
но при таком раскладе монитор не срабатывает. Если послать exit менеджеру, то уведомление о его закрытии не приходит.
Почему?

#### -------------------------

### Послать stop менеджеру

```
8> keylist_mgr:start().             
{ok,<0.104.0>,#Ref<0.3229550752.3956015107.1945>}
9> keylist_mgr ! {self(), start_child, keylist1}.
{<0.80.0>,start_child,keylist1}
10> keylist_mgr ! {self(), start_child, keylist2}.
{<0.80.0>,start_child,keylist2}
11> keylist_mgr ! {self(), start_child, keylist3}.
{<0.80.0>,start_child,keylist3}
12> whereis(keylist3).
<0.110.0>
13> keylist_mgr ! stop.
stop
14> flush().
Shell got [{ok,<0.106.0>}]
Shell got [{ok,<0.108.0>}]
Shell got [{ok,<0.110.0>}]
Shell got {'DOWN',#Ref<0.3229550752.3956015107.1945>,process,<0.104.0>,stop}
ok
15> self().
<0.80.0>
16> 
```

#### ----===/ Комментарий /===----

Ситуация аналогична с "Убийство mgr процесса"

#### -------------------------
