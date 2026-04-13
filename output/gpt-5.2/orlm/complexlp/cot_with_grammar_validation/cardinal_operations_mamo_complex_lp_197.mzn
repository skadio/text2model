% Parameters
int: S = 5; % securities
int: C = 5; % countries (states)

set of int: SEC = 1..S;
set of int: CTY = 1..C;

% prices in cents (to avoid floats)
array[SEC] of int: price = [75, 35, 40, 75, 65];

% share limits
array[SEC] of int: limit = [10, 5, 10, 10, 5];

% payoff in cents per share for each (security, country)
% Country order: 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain
array[SEC, CTY] of int: payoff =
  [| 100, 100, 100,   0,   0  % Sec 1
   |   0,   0,   0, 100, 100  % Sec 2
   | 100,   0, 100,   0, 100  % Sec 3
   | 100, 100, 100, 100,   0  % Sec 4
   |   0, 100,   0, 100, 100  % Sec 5
  |];

% Variables
array[SEC] of var 0..10: x;          % shares bought (bounded; further limited below)
var int: w;                           % worst-case profit in cents

% Constraints
constraint forall(i in SEC) (x[i] <= limit[i]);

% worst-case profit across all countries:
% profit(country j) = sum_i x[i] * (payoff[i,j] - price[i])
constraint forall(j in CTY) (
  w <= sum(i in SEC) ( x[i] * (payoff[i,j] - price[i]) )
);

% Objective
solve maximize w;