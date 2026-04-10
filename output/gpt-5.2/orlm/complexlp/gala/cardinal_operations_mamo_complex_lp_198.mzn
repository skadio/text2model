include "globals.mzn";

/*
  Maximize worst-case (across World Cup winner outcomes) net revenue:
    net = payoff - cost
  Decision: integer number of shares to buy of each security (bounded by share limits).
*/

/************ Data (embedded) ************/
int: S = 5;  % securities
int: O = 5;  % outcomes/countries

set of int: Sec = 1..S;
set of int: Out = 1..O;

array[Out] of string: country = ["Argentina","Brazil","England","Germany","Spain"];

% Prices per share (in dollars)
array[Sec] of int: priceC = [75, 35, 40, 75, 65]; % cents to keep integrality

% Share limits
array[Sec] of int: limit = [10, 5, 10, 10, 5];

% Payoff per share, in cents, contingent on outcome (row = security, col = outcome)
% Outcomes order: Argentina, Brazil, England, Germany, Spain
array[Sec, Out] of int: payoffC = array2d(Sec, Out, [
  100,100,100,  0,  0,   % Sec 1
    0,  0,  0,100,100,   % Sec 2
  100,  0,100,  0,100,   % Sec 3
  100,100,100,100,  0,   % Sec 4
    0,100,  0,100,100    % Sec 5
]);

/************ Decision variables ************/
array[Sec] of var 0..max(limit): x;     % shares purchased of each security
var int: worstC;                        % worst-case net revenue, in cents

/************ Constraints ************/
% Respect individual share limits
constraint forall(s in Sec)(x[s] <= limit[s]);

% Define worst-case revenue across all outcomes
% net(out) = sum_s x[s]*(payoffC[s,out] - priceC[s])
constraint forall(o in Out)(
  worstC <= sum(s in Sec)( x[s] * (payoffC[s,o] - priceC[s]) )
);

/************ Objective ************/
solve maximize worstC;

/************ Output ************/
output [
  "Shares x = ", show(x), "\n",
  "Worst-case net revenue (cents) = ", show(worstC), "\n",
  "Worst-case net revenue ($) = ", show(worstC div 100), ".", 
    if abs(worstC) mod 100 < 10 then "0" else "" endif, show(abs(worstC) mod 100), "\n",
  "Net revenue by outcome (cents):\n"
] ++
[
  "  " ++ country[o] ++ ": " ++
  show(sum(s in Sec)( x[s] * (payoffC[s,o] - priceC[s]) )) ++ "\n"
  | o in Out
];