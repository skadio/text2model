% Parameters (with values embedded)
int: guests_needed = 80;
int: golf_capacity = 4;
int: pull_capacity = 1;
int: pct_golf_max_num = 60;   % percent
int: pct_golf_max_den = 100;

% Variables
var 0..guests_needed: golf_carts;
var 0..guests_needed: pull_carts;
var 0..2*guests_needed: total_carts;

% Constraints
constraint total_carts = golf_carts + pull_carts;

constraint golf_capacity * golf_carts + pull_capacity * pull_carts >= guests_needed;

% At most 60% of all carts are golf carts:
% golf_carts / total_carts <= 60/100  ->  100*golf_carts <= 60*total_carts
constraint pct_golf_max_den * golf_carts <= pct_golf_max_num * total_carts;

% Objective
solve minimize total_carts;