% Parameters (with values embedded)
int: N = 5; % number of securities
int: M = 5; % number of countries/outcomes

set of int: SEC = 1..N;
set of int: OUT = 1..M; % 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain

array[SEC] of float: price = [0.75, 0.35, 0.40, 0.75, 0.65];
array[SEC] of int: shareLimit = [10, 5, 10, 10, 5];

% payoff[s,o] is the payoff ($) of 1 share of security s if outcome o occurs
array[SEC, OUT] of int: payoff =
  [| 1, 1, 1, 0, 0  % Security 1
   | 0, 0, 0, 1, 1  % Security 2
   | 1, 0, 1, 0, 1  % Security 3
   | 1, 1, 1, 1, 0  % Security 4
   | 0, 1, 0, 1, 1  % Security 5
  |];

% To avoid floats, scale all monetary values by 100
int: SCALE = 100;
array[SEC] of int: priceC = [round(price[s] * SCALE) | s in SEC];

% Variables
array[SEC] of var int: x;          % number of shares purchased of each security
var int: z;                        % worst-case (minimum over outcomes) net revenue, in cents

% Constraints
constraint forall(s in SEC) (
  0 <= x[s] /\ x[s] <= shareLimit[s]
);

% Worst-case net revenue:
% For each outcome o: net(o) = sum_s x[s]*(payoff[s,o]*100 - priceC[s])
% Enforce z <= net(o) for all outcomes, then maximize z.
constraint forall(o in OUT) (
  z <= sum(s in SEC) ( x[s] * (payoff[s,o] * SCALE - priceC[s]) )
);

% Objective
solve maximize z;