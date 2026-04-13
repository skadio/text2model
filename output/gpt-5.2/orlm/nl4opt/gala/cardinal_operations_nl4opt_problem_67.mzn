include "globals.mzn";

% Data (embedded from problem statement)
int: max_total_units = 300;
int: min_fertilizer = 50;

% Time per unit (minutes)
float: t_fertilizer = 0.5;
float: t_seeds      = 1.5;

% Decision variables
var 0..max_total_units: F; % fertilizer units
var 0..max_total_units: S; % seeds units

% Constraints
constraint F + S <= max_total_units;
constraint F >= min_fertilizer;
constraint F <= 2 * S; % at most twice fertilizer as seeds

% Objective: minimize total time
var float: total_time = t_fertilizer * int2float(F) + t_seeds * int2float(S);

solve minimize total_time;

output [
  "Fertilizer units (F) = ", show(F), "\n",
  "Seeds units (S)      = ", show(S), "\n",
  "Total time (min)     = ", show(total_time), "\n"
];