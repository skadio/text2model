include "globals.mzn";

% Data (embedded from the problem statement)
int: req_hours = 500;
int: budget = 15000;

int: hours_full = 8;
int: hours_part = 4;

int: cost_full = 300;
int: cost_part = 100;

% Decision variables: number of workers (shifts) scheduled of each type
var 0..req_hours div hours_full + 1: full; % safe upper bound
var 0..req_hours div hours_part + 1: part; % safe upper bound

% Constraints
constraint hours_full * full + hours_part * part >= req_hours;
constraint cost_full * full + cost_part * part <= budget;

% Objective: minimize total number of workers
var 0..(req_hours div hours_full + 1) + (req_hours div hours_part + 1): total_workers;
constraint total_workers = full + part;

solve minimize total_workers;

output [
  "full = ", show(full), "\n",
  "part = ", show(part), "\n",
  "total_workers = ", show(total_workers), "\n",
  "hours = ", show(hours_full * full + hours_part * part), "\n",
  "cost = ", show(cost_full * full + cost_part * part), "\n"
];