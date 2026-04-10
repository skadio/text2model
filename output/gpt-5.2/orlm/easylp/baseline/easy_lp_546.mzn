% Supply chain allocation: raw materials, labor, transportation

int: cost_raw = 4;
int: cost_labor = 3;
int: cost_trans = 2;

var int: raw >= 0;
var int: labor >= 0;
var int: trans >= 0;

% Constraints
constraint raw + labor >= 50;
constraint abs(labor - trans) <= 10;
constraint raw - labor = 20;
constraint raw + trans <= 100;

% Objective: minimize total cost
var int: total_cost = cost_raw * raw + cost_labor * labor + cost_trans * trans;
solve minimize total_cost;

output [
  "raw=", show(raw), "\n",
  "labor=", show(labor), "\n",
  "trans=", show(trans), "\n",
  "total_cost=", show(total_cost), "\n"
];