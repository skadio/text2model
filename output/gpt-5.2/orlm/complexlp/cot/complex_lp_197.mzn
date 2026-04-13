% Parameters (with values embedded)
int: S = 5; % number of securities
int: C = 5; % number of countries/outcomes

set of int: SEC = 1..S;
set of int: OUT = 1..C;

% Countries (indexing): 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain
array[SEC] of float: price = [0.75, 0.35, 0.40, 0.75, 0.65];
array[SEC] of int: shareLimit = [10, 5, 10, 10, 5];

% payoff[s,o] in dollars per share if outcome o occurs
array[SEC, OUT] of int: payoff =
[
  % A  B  E  G  S
    1, 1, 1, 0, 0,  % Security 1
    0, 0, 0, 1, 1,  % Security 2
    1, 0, 1, 0, 1,  % Security 3
    1, 1, 1, 1, 0,  % Security 4
    0, 1, 0, 1, 1   % Security 5
];

% Scale money by 100 to keep integrality
int: SCALE = 100;
array[SEC] of int: priceCents = [round(price[s] * SCALE) | s in SEC];

% Variables
array[SEC] of var 0..max(shareLimit): x;     % shares purchased
var int: worstRevenueCents;                  % maximum worst-case revenue (in cents)

% Constraints
constraint forall(s in SEC) (
  x[s] <= shareLimit[s]
);

% Worst-case revenue across outcomes:
% revenue(o) = sum_s x[s]*(payoff[s,o]*100 - priceCents[s])
constraint forall(o in OUT) (
  worstRevenueCents <= sum(s in SEC) ( x[s] * (payoff[s,o]*SCALE - priceCents[s]) )
);

% Objective
solve maximize worstRevenueCents;

output [
  "worstRevenueCents=", show(worstRevenueCents), "\n",
  "worstRevenueDollars_rounded=", show( (worstRevenueCents + 50) div 100 ), "\n",
  "x=", show(x), "\n"
];