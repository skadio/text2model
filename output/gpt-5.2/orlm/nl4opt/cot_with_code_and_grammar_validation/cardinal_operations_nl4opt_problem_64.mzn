% Parameters
int: cap_old = 100;
int: cap_new = 80;
int: pol_old = 50;
int: pol_new = 30;
int: demand = 5000;
int: max_new = 30;

% Variables
var 0..(demand div cap_old + 1): n_old;
var 0..max_new: n_new;

% Constraints
constraint cap_old * n_old + cap_new * n_new >= demand;

% Objective
solve minimize pol_old * n_old + pol_new * n_new;