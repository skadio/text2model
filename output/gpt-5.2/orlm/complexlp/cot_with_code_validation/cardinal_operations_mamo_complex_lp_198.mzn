% Parameters
int: S = 5; % number of securities
int: C = 5; % number of countries/outcomes

set of int: SEC = 1..S;
set of int: OUT = 1..C;

% Countries order: 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain
array[SEC] of float: price = [0.75, 0.35, 0.40, 0.75, 0.65];
array[SEC] of int: limit = [10, 5, 10, 10, 5];

% payoff[s,o] in dollars per share if outcome o occurs
array[SEC, OUT] of int: payoff =
  [| 1, 1, 1, 0, 0   % Security 1
   | 0, 0, 0, 1, 1   % Security 2
   | 1, 0, 1, 0, 1   % Security 3
   | 1, 1, 1, 1, 0   % Security 4
   | 0, 1, 0, 1, 1   % Security 5
  |];

% Scale to avoid floats (cents)
int: SCALE = 100;
array[SEC] of int: priceC = [round(price[s] * SCALE) | s in SEC];

% Variables
array[SEC] of var 0..max(limit): x;           % shares purchased
var 0..1000000: worstRevenueC;                % worst-case revenue in cents

% Constraints
constraint forall(s in SEC) (x[s] <= limit[s]);

% worstRevenueC <= revenue in each outcome
constraint forall(o in OUT) (
  worstRevenueC <=
    sum(s in SEC) (SCALE * payoff[s,o] * x[s]) - sum(s in SEC) (priceC[s] * x[s])
);

% Objective
solve maximize worstRevenueC;