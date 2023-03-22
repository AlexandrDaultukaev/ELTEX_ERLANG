-module(persons).

% rr("person.hrl").
% Persons = [#person{id=1, name="Bob", age=23, gender=male}, #person{id=2, name="Kate", age=20, gender=female}, #person{id=2, name="Jack", age=34, gender=male}, #person{id=4, name="Nata", age=54, gender=female}].
-include("person.hrl").

-export([filter/2, all/2, any/2, update/2, get_average_age/1]).

% persons:filter((fun(#person{age = Age}) -> Age >= 30 end, Persons)
filter(Fun, Persons) -> lists:filter(Fun, Persons).
all(Fun, Persons) -> lists:all(Fun, Persons).
any(Fun, Persons) -> lists:any(Fun, Persons).
update(Fun, Persons) -> lists:map(Fun, Persons).


get_average_age([]) -> io:format("List can't be empty!\n"), {error, badarg};
get_average_age(Persons) ->
    getPersonsNumberAndAgeSum = fun(#person{age = Age}, {Count, AgeSum}) -> {Count+1, AgeSum+Age} end,
    {_PersonsCount, _AgeSum} = lists:foldl(getPersonsNumberAndAgeSum, {0, 0}, Persons),
    {ok, _AgeSum/_PersonsCount}.

% UpdateJackAge = fun(
%     #person{name = "Jack", age = Age} = Person) -> Person#person{age=Age + 1};
%     (Person) -> Person end.
