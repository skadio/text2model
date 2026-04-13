% Parameters
int: S = 5; % securities
int: C = 5; % countries (states)

set of int: SEC = 1..S;
set of int: CTY = 1..C;

array[SEC] of int: price_cents = [75, 35, 40, 75, 65]; % prices in cents
array[SEC] of int: limit = [10, 5, 10, 10, 5]; % share limits

% payoff[s,c] in dollars (0/1)
% Country order: 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain
array[SEC, CTY] of int: payoff = array2d(SEC, CTY,
[
  1,1,1,0,0,  % Sec 1
  0,0,0,1,1,  % Sec 2
  1,0,1,0,1,  % Sec 3
  1,1,1,1,0,  % Sec 4
  0,1,0,1,1   % Sec 5
]);

% Variables
array[SEC] of var 0..10: x;          % shares purchased (bounded further by limit)
var 0..1000000: worst_profit_cents;  % worst-case profit in cents

% Constraints
constraint forall(s in SEC) (x[s] <= limit[s]);

% worst_profit_cents <= profit_cents[c] for every country c
constraint forall(c in CTY) (
  worst_profit_cents <=
    sum(s in SEC)(100 * payoff[s,c] * x[s]) - sum(s in SEC)(price_cents[s] * x[s])
);

% Objective
solve maximize worst_profit_cents;