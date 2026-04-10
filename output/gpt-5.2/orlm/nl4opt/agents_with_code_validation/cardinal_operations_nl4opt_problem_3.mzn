% Parameters
int: cones_per_counter = 80;          % cones/day produced by one counter-top machine
int: cones_per_fridge  = 150;         % cones/day produced by one fridge-sized machine

int: heat_per_counter  = 50;          % heat units/day produced by one counter-top machine
int: heat_per_fridge   = 70;          % heat units/day produced by one fridge-sized machine

int: max_heat          = 500;         % maximum allowed heat units/day
int: min_cones         = 1000;        % minimum required cones/day

% Upper bounds derived from constraints (safe, finite bounds for decision vars)
int: max_counter_by_heat  = max_heat div heat_per_counter;
int: max_fridge_by_heat   = max_heat div heat_per_fridge;

% Variables
var 0..max_counter_by_heat: n_counter;  % number of counter-top machines to buy
var 0..max_fridge_by_heat:  n_fridge;   % number of fridge-sized machines to buy

% Constraints
% Heat limit: total daily heat produced by all machines cannot exceed max_heat
constraint
  heat_per_counter * n_counter + heat_per_fridge * n_fridge <= max_heat;

% Production requirement: total daily cones produced must be at least min_cones
constraint
  cones_per_counter * n_counter + cones_per_fridge * n_fridge >= min_cones;

% Objective
solve minimize n_counter + n_fridge;