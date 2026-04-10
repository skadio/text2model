% Parameters
int: dough_req_large = 12;
int: topping_req_large = 5;
int: bake_time_large = 12;

int: dough_req_medium = 8;
int: topping_req_medium = 4;
int: bake_time_medium = 8;

int: min_total_dough = 10000;
int: min_total_toppings = 4400;

int: min_medium = 200;

% Variables
var 0..1250: L;  % number of large pizzas (upper bound from dough: 10000/8 = 1250)
var 0..1250: M;  % number of medium pizzas

var 0..25000: total_bake_time;

% Constraints
constraint 12 * L + 8 * M >= min_total_dough;
constraint 5 * L + 4 * M >= min_total_toppings;

constraint M >= min_medium;

constraint L >= 2 * M;

constraint total_bake_time = bake_time_large * L + bake_time_medium * M;

% Objective
solve minimize total_bake_time;