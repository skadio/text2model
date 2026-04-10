% Supply chain resource allocation (all data embedded)
include "globals.mzn";

% Decision variables (integer allocations)
var int: raw;     % raw material units
var int: labor;   % labor units
var int: trans;   % transportation units

% Costs
int: c_raw = 5;
int: c_labor = 4;
int: c_trans = 6;

% Objective: minimize total cost
var int: total_cost = c_raw * raw + c_labor * labor + c_trans * trans;

% Practical nonnegativity
constraint raw >= 0 /\ labor >= 0 /\ trans >= 0;

% Constraints from description
constraint raw >= 2 * labor + 500;
constraint labor + trans <= 1000;
constraint raw = trans + 200;

solve minimize total_cost;

output [
  "raw = ", show(raw), "\n",
  "labor = ", show(labor), "\n",
  "trans = ", show(trans), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];