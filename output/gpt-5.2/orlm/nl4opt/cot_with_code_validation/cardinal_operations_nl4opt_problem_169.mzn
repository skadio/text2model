% Parameters
int: golf_capacity = 4;
int: pull_capacity = 1;
int: min_guests = 80;
int: max_golf_fraction_num = 60;
int: max_golf_fraction_den = 100;

% Variables
var 0..min_guests: golf_carts;
var 0..min_guests: pull_carts;
var 0..(golf_capacity*min_guests + pull_capacity*min_guests): total_guests;
var 0..(2*min_guests): total_carts;

% Constraints
constraint total_guests = golf_capacity * golf_carts + pull_capacity * pull_carts;
constraint total_guests >= min_guests;

constraint total_carts = golf_carts + pull_carts;

% At most 60% of carts can be golf carts:
constraint max_golf_fraction_den * golf_carts <= max_golf_fraction_num * total_carts;

% Objective
solve minimize total_carts;