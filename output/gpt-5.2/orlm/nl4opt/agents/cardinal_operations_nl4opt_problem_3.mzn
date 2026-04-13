% Parameters
int: cones_per_counter = 80;        % Cones produced per day by a counter-top machine
int: cones_per_fridge  = 150;       % Cones produced per day by a fridge-sized machine

int: heat_per_counter  = 50;        % Heat units per day from a counter-top machine
int: heat_per_fridge   = 70;        % Heat units per day from a fridge-sized machine

int: max_heat          = 500;       % Maximum allowed heat units per day
int: min_cones         = 1000;      % Minimum required cones per day

% Variables
var 0..(max_heat div heat_per_counter): n_counter;  % Number of counter-top machines
var 0..(max_heat div heat_per_fridge):  n_fridge;   % Number of fridge-sized machines

% Constraints
% Cone production requirement: total cones produced must meet or exceed the minimum demand
constraint
  cones_per_counter * n_counter + cones_per_fridge * n_fridge >= min_cones;

% Heat limit requirement: total heat output must not exceed the maximum allowed
constraint
  heat_per_counter * n_counter + heat_per_fridge * n_fridge <= max_heat;

% Objective
solve minimize n_counter + n_fridge;