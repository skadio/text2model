% Parameters
int: heat_new = 10;
int: heat_old = 15;
int: kwh_new = 200;
int: kwh_old = 250;

int: min_apartments = 200;
int: max_kwh = 3500;

float: max_old_fraction = 0.35;
int: min_new = 5;

% Variables
var 0..1000: n_new;
var 0..1000: n_old;
var 0..2000: total;

% Constraints
constraint total = n_new + n_old;

constraint n_new >= min_new;

constraint heat_new * n_new + heat_old * n_old >= min_apartments;

constraint kwh_new * n_new + kwh_old * n_old <= max_kwh;

% At most 35% old: n_old / total <= 0.35  ->  100*n_old <= 35*total
constraint total > 0;
constraint 100 * n_old <= 35 * total;

% Objective
solve minimize total;