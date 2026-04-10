% Parameters
int: golf_capacity = 4;
int: pull_capacity = 1;
int: min_guests = 80;
float: max_golf_fraction = 0.6;

% Variables
var 0..min_guests: golf_carts;
var 0..min_guests: pull_carts;
var 0..(2 * min_guests): total_carts;

% Constraints
constraint total_carts = golf_carts + pull_carts;

constraint golf_capacity * golf_carts + pull_capacity * pull_carts >= min_guests;

% at most 60% of carts can be golf carts:
% golf_carts / total_carts <= 0.6  <=>  golf_carts <= 0.6 * total_carts
% avoid division and floats by cross-multiplying:
constraint 10 * golf_carts <= 6 * total_carts;

% Objective
solve minimize total_carts;