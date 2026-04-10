% Parameters
int: heat_new = 10;
int: heat_old = 15;
int: kwh_new = 200;
int: kwh_old = 250;

int: min_new = 5;
float: max_old_frac = 0.35;

int: min_apartments = 200;
int: max_kwh = 3500;

% Variables
var 0..(max_kwh div kwh_new): x_new;
var 0..(max_kwh div kwh_old): x_old;

var 0..(max_kwh div min(kwh_new, kwh_old)): total;

% Constraints
constraint total = x_new + x_old;

constraint x_new >= min_new;

constraint heat_new * x_new + heat_old * x_old >= min_apartments;

constraint kwh_new * x_new + kwh_old * x_old <= max_kwh;

constraint x_old <= floor(max_old_frac * int2float(total));

% Objective
solve minimize total;