% Parameters
int: pigeon_capacity = 2;
int: pigeon_cost = 3;
int: owl_capacity = 5;
int: owl_cost = 5;

float: max_owl_fraction = 0.40;
int: treats_available = 1000;
int: min_pigeons = 20;

% Variables
var 0..(treats_available div pigeon_cost): pigeons;
var 0..(treats_available div owl_cost): owls;

var 0..(pigeon_capacity * (treats_available div pigeon_cost) + owl_capacity * (treats_available div owl_cost)): letters;

% Constraints
constraint pigeons >= min_pigeons;

constraint pigeon_cost * pigeons + owl_cost * owls <= treats_available;

% At most 40% of the birds can be owls:
% owls <= 0.4 * (pigeons + owls)  <=>  3*owls <= 2*pigeons
constraint 3 * owls <= 2 * pigeons;

constraint letters = pigeon_capacity * pigeons + owl_capacity * owls;

% Objective
solve maximize letters;