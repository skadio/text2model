include "globals.mzn";

% Decision variables (MW produced, whole numbers)
var 0..10000: coal;
var 0..10000: gas;
var 0..10000: nuclear;

% Demand constraint
constraint coal + gas + nuclear >= 500;

% Environmental/safety measures (scaled by 10 to avoid fractions)
% (1/2)*coal - (1/5)*gas + 1*nuclear <= 200
constraint 5*coal - 2*gas + 10*nuclear <= 2000;

% 1*coal - 1*gas + 0.4*nuclear >= 150
constraint 10*coal - 10*gas + 4*nuclear >= 1500;

% Objective: minimize total cost
var int: total_cost = 20*coal + 30*gas + 40*nuclear;

solve minimize total_cost;

output [
  "coal=", show(coal), " MW\n",
  "gas=", show(gas), " MW\n",
  "nuclear=", show(nuclear), " MW\n",
  "total_cost=$", show(total_cost), "\n"
];