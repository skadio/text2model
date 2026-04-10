% Parameters
int: prod_counter = 80;
int: prod_fridge  = 150;
int: heat_counter = 50;
int: heat_fridge  = 70;
int: heat_max     = 500;
int: prod_min     = 1000;

% Variables
var 0..ceil(int2float(prod_min) / int2float(prod_counter)): x_counter;
var 0..ceil(int2float(prod_min) / int2float(prod_fridge)):  x_fridge;
var 0..(ceil(int2float(prod_min) / int2float(prod_counter)) + ceil(int2float(prod_min) / int2float(prod_fridge))): total_machines;

% Constraints
constraint prod_counter * x_counter + prod_fridge * x_fridge >= prod_min;
constraint heat_counter * x_counter + heat_fridge * x_fridge <= heat_max;
constraint total_machines = x_counter + x_fridge;

% Objective
solve minimize total_machines;