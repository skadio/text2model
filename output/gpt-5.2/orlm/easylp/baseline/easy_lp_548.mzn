% Supply chain resource allocation (all data embedded)

int: cost_raw = 5;
int: cost_labor = 4;
int: cost_trans = 6;

% Decision variables (integer allocations)
var int: raw;
var int: labor;
var int: trans;

% Nonnegativity (practical allocations)
constraint raw >= 0 /\ labor >= 0 /\ trans >= 0;

% Constraints from problem statement
constraint raw >= 2 * labor + 500;
constraint labor + trans <= 1000;
constraint raw = trans + 200;

% Objective: minimize total cost
var int: total_cost = cost_raw * raw + cost_labor * labor + cost_trans * trans;
solve minimize total_cost;

output [
  "raw=", show(raw), "\n",
  "labor=", show(labor), "\n",
  "trans=", show(trans), "\n",
  "total_cost=", show(total_cost), "\n"
];