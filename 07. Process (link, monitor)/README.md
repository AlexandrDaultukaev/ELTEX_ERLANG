

Проверьте ваш pid (self/0).
Создайте 2 процесса PidMonitor, PidLinked:
keylist:start(monitored).
keylist:start_link(linked).
Отправьте сообщения процессу Linked. С любыми данными типа {Key, Value, Comment}.
Протестистируйте, что процесс Linked обрабатывает ваши сообщений, работает со списком и
возвращает результат. Проверьте почтовый ящик вашего процесса (flush/0).
В READme добавьте copy-paste консоли результатов тестирования.

```
2> PidLinked = keylist:start_link(linked). erlang:send(PidLinked, {self(), add, "One", "Two", "Three"}).
<0.88.0>
3> erlang:send(PidLinked, {self(), add, "One", "Two", "Three"}).
{<0.80.0>,add,"One","Two","Three"}
4> flush().
Shell got {ok,{state,[{"One","Two","Three"}],1}}
ok
5> erlang:send(PidLinked, {self(), add, "1", "2", "3"}).
{<0.80.0>,add,"1","2","3"}
6> erlang:send(PidLinked, {self(), is_member, "1"}). 
{<0.80.0>,is_member,"1"}
7> 
7> flush(). 
Shell got {ok,{state,[{"1","2","3"},{"One","Two","Three"}],2}}
Shell got {ok,true}
ok
8> erlang:send(PidLinked, {self(), take, "1"}).
{<0.80.0>,take,"1"}
9> flush().
Shell got {ok,{value,{"1","2","3"},[{"One","Two","Three"}]}}
ok
10> erlang:send(PidLinked, {self(), find, "1"}).
{<0.80.0>,find,"1"}
11> flush().
Shell got {ok,{"1","2","3"}}
ok
12> erlang:send(PidLinked, {self(), delete, "1"}).
{<0.80.0>,delete,"1"}
13> flush().
Shell got {ok,[{"One","Two","Three"}]}
ok
14> erlang:send(PidLinked, {self(), add, "11", "22", "33"}).
{<0.80.0>,add,"11","22","33"}
15> flush().
Shell got {ok,{state,[{"11","22","33"},{"One","Two","Three"}],7}}
ok
```


3. Eshell:
Завершите процесс Monitored с помощью функции exit(Pid, Reason).
P.s. Чтобы найти Pid по имени мы можем использовать команду whereis/1.
Проверьте почтовый ящик вашего процесса (flush/0).
Проверьте ваш pid (self/0).
Прокомментируйте содержимое почтового ящика и изменился ли ваш pid.

![Снимок экрана от 2023-03-26 19-16-47](https://user-images.githubusercontent.com/60806892/227775432-703ab241-e3a4-4d45-8b02-704373332acf.png)

-----====/ <b><i>Комментарий</i></b> /====-----

Monitor, как бы следит за процессом и в почтовый ящик пришло сообщение о том, что процесс упал. Характерно для monitor видеть сообщение 'DOWN', а не 'EXIT', как при link.
Monitor не связывает процессы друг с другом, поэтому pid не изменился.

------------------


Завершите процесс Linked с помощью функции exit(Pid, Reason).
Проверьте почтовый ящик вашего процесса (flush/0).
Проверьте ваш pid (self/0).
Прокомментируйте происходящее и изменился ли ваш pid.
![Снимок экрана от 2023-03-26 19-18-40](https://user-images.githubusercontent.com/60806892/227775612-4a7f4cae-0204-41e9-bbf7-18ca177f8697.png)

-----====/ <b><i>Комментарий</i></b> /====-----

Link связывает процессы и,если один упал, упадёт и связанный с ним. Поэтому Pid изменился.

------------------------------

4. Eshell:
Вызовите функцию process_flag(trap_exit, true).
Запустите еще раз keylist:start_link(linked).
Завершите процесс Linked с помощью функции exit(Pid, Reason).

Проверьте почтовый ящик вашего процесса (flush/0).
Проверьте ваш pid (self/0).
Прокомментируйте содержимое почтового ящика и изменился ли ваш pid.
![Снимок экрана от 2023-03-26 19-19-59](https://user-images.githubusercontent.com/60806892/227775749-fa53f70d-3920-4b97-a7ef-6aafba9ff25c.png)

-----====/ <b><i>Комментарий</i></b> /====-----

Pid не изменился, так как использовался trap_exit, позволяющий отлавливать выход, когда связанный процесс завершается.

------------------------------

