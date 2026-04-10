% Ice cream machine purchasing optimization
% Data embedded as requested.

include "globals.mzn";

% Parameters
int: prod_counter = 80;     % cones/day
int: prod_fridge  = 150;    % cones/day
int: heat_counter = 50;     % heat units/day
int: heat_fridge  = 70;     % heat units/day

int: max_heat = 500;
int: min_cones = 1000;

% Decision variables: number of each machine to buy
% Upper bounds derived from heat limit
var 0..(max_heat div heat_counter): n_counter; % <= 10
var 0..(max_heat div heat_fridge):  n_fridge;  % <= 7

% Constraints
constraint heat_counter * n_counter + heat_fridge * n_fridge <= max_heat;
constraint prod_counter * n_counter + prod_fridge * n_fridge >= min_cones;

% Objective: minimize total machines
var 0..100: total_machines = n_counter + n_fridge;

solve minimize total_machines;

output [
  "Counter-top machines = ", show(n_counter), "\n",
  "Fridge machines      = ", show(n_fridge), "\n",
  "Total machines       = ", show(total_machines), "\n",
  "Total cones/day      = ", show(prod_counter*n_counter + prod_fridge*n_fridge), "\n",
  "Total heat/day       = ", show(heat_counter*n_counter + heat_fridge*n_fridge), "\n"
];