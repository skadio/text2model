% Device selection + production allocation to minimize total cost
% Data embedded from Table 5-7

include "globals.mzn";

set of int: DEV = 1..4;
int: A = 1; int: B = 2; int: C = 3; int: D = 4;

array[DEV] of int: prepCost = [1000, 920, 800, 700];   % Yuan if device enabled
array[DEV] of int: unitCost = [20, 24, 16, 28];        % Yuan per unit produced
array[DEV] of int: cap      = [900, 1000, 1200, 1600]; % max units if enabled

int: demand = 2000;

% Decision variables
array[DEV] of var 0..1: use;                 % 1 if device enabled
array[DEV] of var 0..max(cap): x;            % units produced on each device

% Constraints
constraint sum(d in DEV)(x[d]) = demand;
constraint forall(d in DEV)(x[d] <= cap[d] * use[d]);  % can produce only if enabled

% Objective: prep + variable production costs
var int: totalCost =
  sum(d in DEV)(prepCost[d] * use[d] + unitCost[d] * x[d]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), " Yuan\n",
  "Use devices [A,B,C,D] = ", show([use[A],use[B],use[C],use[D]]), "\n",
  "Production  [A,B,C,D] = ", show([x[A],x[B],x[C],x[D]]), "\n"
];