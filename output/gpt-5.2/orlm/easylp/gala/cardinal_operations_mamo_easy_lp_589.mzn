include "globals.mzn";

% Costs per unit (given)
int: c_raw = 10;
int: c_labor = 5;
int: c_machine = 15;
int: c_energy = 20;

% Decision variables: whole-number resource units
var 0..10000: raw;
var 0..10000: labor;
var 0..10000: machine;
var 0..10000: energy;

% Constraints (given)
constraint raw >= 2 * labor;
constraint labor <= machine;
constraint machine = energy;
constraint raw + labor + machine + energy >= 500;

% Objective: minimize total cost
var 0..intmax: total_cost = c_raw*raw + c_labor*labor + c_machine*machine + c_energy*energy;

solve minimize total_cost;

output [
  "Minimum total cost = $", show(total_cost), "\n",
  "raw = ", show(raw), "\n",
  "labor = ", show(labor), "\n",
  "machine = ", show(machine), "\n",
  "energy = ", show(energy), "\n"
];