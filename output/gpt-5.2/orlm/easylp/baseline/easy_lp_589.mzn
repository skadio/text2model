% Manufacturing cost minimization with integer resource allocations

int: cost_raw = 10;
int: cost_labor = 5;
int: cost_machine = 15;
int: cost_energy = 20;

% Decision variables (whole numbers)
var 0..100000: raw;
var 0..100000: labor;
var 0..100000: machine;
var 0..100000: energy;

% Constraints
constraint raw >= 2 * labor;
constraint labor <= machine;
constraint machine = energy;
constraint raw + labor + machine + energy >= 500;

% Objective: minimize total cost
var 0..intmax: total_cost =
  cost_raw * raw + cost_labor * labor + cost_machine * machine + cost_energy * energy;

solve minimize total_cost;

output [
  "raw=", show(raw), "\n",
  "labor=", show(labor), "\n",
  "machine=", show(machine), "\n",
  "energy=", show(energy), "\n",
  "total_cost=", show(total_cost), "\n"
];