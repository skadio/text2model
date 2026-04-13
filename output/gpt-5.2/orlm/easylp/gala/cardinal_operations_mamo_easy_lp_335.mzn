include "globals.mzn";

% Power plant types: Coal, Gas, Solar, Nuclear
set of int: P = 1..4;
int: COAL = 1;
int: GAS = 2;
int: SOLAR = 3;
int: NUCLEAR = 4;

% Demand and costs ($/MW)
int: demand = 1000;
array[P] of int: cost = [50, 60, 70, 80];

% Operational bounds (MW)
array[P] of int: minCap = [0, 0, 300, 100];
array[P] of int: maxCap = [600, 400, 10000, 10000];  % large upper bounds where not specified

% Decision variables: integer MW outputs
array[P] of var int: mw;
constraint forall(p in P)(mw[p] >= minCap[p] /\ mw[p] <= maxCap[p]);

% Additional coal regulatory maximum
constraint mw[COAL] <= 500;

% Total capacity at least demand
constraint sum(p in P)(mw[p]) >= demand;

% Solar must exceed nuclear by at least 200 MW
constraint mw[SOLAR] >= mw[NUCLEAR] + 200;

% |Gas - Solar| <= 150 for stability
constraint abs(mw[GAS] - mw[SOLAR]) <= 150;

% Objective: minimize total cost
var int: totalCost = sum(p in P)(cost[p] * mw[p]);

solve minimize totalCost;

output [
  "Coal MW = ", show(mw[COAL]), "\n",
  "Gas MW = ", show(mw[GAS]), "\n",
  "Solar MW = ", show(mw[SOLAR]), "\n",
  "Nuclear MW = ", show(mw[NUCLEAR]), "\n",
  "Total MW = ", show(sum(p in P)(mw[p])), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];