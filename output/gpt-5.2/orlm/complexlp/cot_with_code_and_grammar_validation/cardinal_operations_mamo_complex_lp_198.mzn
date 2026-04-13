% Parameters
int: Nsec = 5;
int: Nstate = 5;

set of int: SEC = 1..Nsec;
set of int: STATE = 1..Nstate;

% States (countries) order: 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain
array[SEC] of int: price_c = [75, 35, 40, 75, 65];  % prices in cents
array[SEC] of int: limit = [10, 5, 10, 10, 5];

array[SEC, STATE] of int: payoff = array2d(SEC, STATE, [
  % A  B  E  G  S
    1, 1, 1, 0, 0,  % Security 1
    0, 0, 0, 1, 1,  % Security 2
    1, 0, 1, 0, 1,  % Security 3
    1, 1, 1, 1, 0,  % Security 4
    0, 1, 0, 1, 1   % Security 5
]);

% Variables
array[SEC] of var int: x;          % shares purchased
var int: w;                         % worst-case revenue (in cents)

% Constraints
constraint forall(s in SEC) (0 <= x[s] /\ x[s] <= limit[s]);

% Worst-case revenue over all possible World Cup outcomes (states)
constraint forall(st in STATE) (
  w <= sum(s in SEC) (payoff[s, st] * x[s]) * 100 - sum(s in SEC) (price_c[s] * x[s])
);

% Objective
solve maximize w;