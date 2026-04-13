% Parameters
int: letters_per_pigeon = 2;
int: letters_per_owl = 5;

int: treats_per_pigeon = 3;
int: treats_per_owl = 5;

int: total_treats = 1000;
int: min_pigeons = 20;

int: owl_num_limit_mult = 2;   % 40% owls => O <= 0.4*(P+O) => 3O <= 2P
int: owl_den_limit_mult = 3;

% Variables
var min_pigeons..(total_treats div treats_per_pigeon): pigeons;
var 0..(total_treats div treats_per_owl): owls;

var 0..(letters_per_pigeon*(total_treats div treats_per_pigeon) + letters_per_owl*(total_treats div treats_per_owl)): total_letters;

% Constraints
constraint treats_per_pigeon * pigeons + treats_per_owl * owls <= total_treats;

% At most 40% of the birds can be owls: 3*owls <= 2*pigeons
constraint owl_den_limit_mult * owls <= owl_num_limit_mult * pigeons;

constraint total_letters = letters_per_pigeon * pigeons + letters_per_owl * owls;

% Objective
solve maximize total_letters;