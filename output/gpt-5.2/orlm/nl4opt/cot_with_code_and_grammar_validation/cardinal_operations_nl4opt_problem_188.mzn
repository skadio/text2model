% Parameters
int: heat_new = 10;
int: heat_old = 15;
int: kwh_new = 200;
int: kwh_old = 250;

int: min_apartments = 200;
int: max_kwh = 3500;

float: max_old_frac = 0.35;
int: min_new = 5;

% Variables
var 0..1000: x_new;
var 0..1000: x_old;
var 0..2000: x_total;

% Constraints
constraint x_total = x_new + x_old;

constraint heat_new * x_new + heat_old * x_old >= min_apartments;
constraint kwh_new * x_new + kwh_old * x_old <= max_kwh;

constraint x_new >= min_new;

% At most 35% old: x_old <= 0.35 * (x_new + x_old)
% Implemented without floats: 100*x_old <= 35*(x_new + x_old)  <=>  65*x_old <= 35*x_new
constraint 65 * x_old <= 35 * x_new;

% Objective
solve minimize x_total;