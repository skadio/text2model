% Parameters
int: cap_old = 100;
int: cap_new = 80;
int: pol_old = 50;
int: pol_new = 30;
int: demand = 5000;
int: max_new = 30;

% Variables
var 0..ceil(demand div cap_old) + ceil(demand div cap_new): x_old;
var 0..max_new: x_new;
var 0..(pol_old*(ceil(demand div cap_old) + ceil(demand div cap_new))): total_pollution;

% Constraints
constraint cap_old * x_old + cap_new * x_new >= demand;
constraint total_pollution = pol_old * x_old + pol_new * x_new;

% Objective
solve minimize total_pollution;