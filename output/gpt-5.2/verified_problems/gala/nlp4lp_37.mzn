% Diet optimization (min-cost to meet nutrient demands)
% Data provided via .dzn:
%   int: K;
%   int: M;
%   array[1..K] of int: Price;
%   array[1..M] of int: Demand;
%   array[1..K, 1..M] of int: Nutrition;

include "globals.mzn";

int: K;
int: M;

array[1..K] of int: Price;
array[1..M] of int: Demand;
array[1..K, 1..M] of int: Nutrition;

% Decision variables: how many units of each food to buy (nonnegative integers)
array[1..K] of var int: buy;
constraint forall(k in 1..K)(buy[k] >= 0);

% Meet or exceed each nutrient demand
constraint
  forall(m in 1..M)(
    sum(k in 1..K)(Nutrition[k,m] * buy[k]) >= Demand[m]
  );

% Objective: minimize total cost
var int: total_cost = sum(k in 1..K)(Price[k] * buy[k]);

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Buy = ", show(buy), "\n",
  "Nutrients supplied = ", show([sum(k in 1..K)(Nutrition[k,m] * buy[k]) | m in 1..M]), "\n"
];