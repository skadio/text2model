% Parameters
int: prod_counter = 80;
int: prod_fridge  = 150;

int: heat_counter = 50;
int: heat_fridge  = 70;

int: max_heat = 500;
int: min_cones = 1000;

% Variables
var 0..ceil(int2float(max_heat) / int2float(heat_counter)): x_counter;
var 0..ceil(int2float(max_heat) / int2float(heat_fridge)):  x_fridge;

% Constraints
constraint prod_counter * x_counter + prod_fridge * x_fridge >= min_cones;
constraint heat_counter * x_counter + heat_fridge * x_fridge <= max_heat;

% Objective
solve minimize x_counter + x_fridge;