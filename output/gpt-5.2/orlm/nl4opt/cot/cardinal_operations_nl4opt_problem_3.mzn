% Parameters (with values embedded)
int: cones_counter = 80;
int: cones_fridge  = 150;
int: heat_counter  = 50;
int: heat_fridge   = 70;

int: max_heat = 500;
int: min_cones = 1000;

% Variable bounds (safe upper bounds from heat limit)
int: max_counter = max_heat div heat_counter; % 500/50 = 10
int: max_fridge  = max_heat div heat_fridge;  % 500/70 = 7

% Variables
var 0..max_counter: x_counter; % number of counter-top machines
var 0..max_fridge:  x_fridge;  % number of fridge-sized machines

% Constraints
constraint heat_counter * x_counter + heat_fridge * x_fridge <= max_heat;
constraint cones_counter * x_counter + cones_fridge * x_fridge >= min_cones;

% Objective
solve minimize x_counter + x_fridge;