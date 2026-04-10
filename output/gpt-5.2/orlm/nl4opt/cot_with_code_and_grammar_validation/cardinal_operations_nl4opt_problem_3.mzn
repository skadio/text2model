% Parameters
int: prod_counter = 80;
int: prod_fridge = 150;
int: heat_counter = 50;
int: heat_fridge = 70;
int: max_heat = 500;
int: min_cones = 1000;

% Variables
var 0..max_heat div heat_counter: x_counter;
var 0..max_heat div heat_fridge: x_fridge;

% Constraints
constraint heat_counter * x_counter + heat_fridge * x_fridge <= max_heat;
constraint prod_counter * x_counter + prod_fridge * x_fridge >= min_cones;

% Objective
solve minimize x_counter + x_fridge;