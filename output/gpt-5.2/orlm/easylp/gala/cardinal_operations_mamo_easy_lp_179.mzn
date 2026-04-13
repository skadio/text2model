include "globals.mzn";

% Data (embedded from the problem description)
int: demand = 1000;

int: coal_cost = 50;
int: gas_cost = 40;
int: nuclear_cost = 60;

int: env_limit = 500;  % 3*coal - gas <= 500
int: nuc_extra = 200;  % nuclear >= 2*gas + 200

% Decision variables (whole numbers, nonnegative)
var 0..demand: coal;
var 0..demand: gas;
var 0..demand: nuclear;

% Constraints
constraint coal + gas + nuclear >= demand;
constraint 3 * coal - gas <= env_limit;
constraint nuclear >= 2 * gas + nuc_extra;

% Objective: minimize total cost
var int: total_cost = coal_cost * coal + gas_cost * gas + nuclear_cost * nuclear;

solve minimize total_cost;

output [
  "coal = ", show(coal), "\n",
  "gas = ", show(gas), "\n",
  "nuclear = ", show(nuclear), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];