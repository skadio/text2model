% Parameters (with values embedded)
int: dough_large = 12;
int: top_large  = 5;
int: time_large = 12;

int: dough_medium = 8;
int: top_medium  = 4;
int: time_medium = 8;

int: min_dough = 10000;
int: min_toppings = 4400;

int: min_medium = 200;

% Variables
var 0..2000: L; % number of large pizzas (upper bound chosen safely)
var 0..2000: M; % number of medium pizzas (upper bound chosen safely)

% Constraints
constraint dough_large * L + dough_medium * M >= min_dough;
constraint top_large  * L + top_medium  * M >= min_toppings;

constraint M >= min_medium;
constraint L >= 2 * M;

% Objective
solve minimize time_large * L + time_medium * M;