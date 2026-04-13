% Parameters
int: min_calcium = 100;
int: min_iron = 50;

int: cost_milk = 1;
int: cost_veg = 2;

int: calcium_milk = 40;
int: iron_milk = 25;

int: calcium_veg = 15;
int: iron_veg = 30;

% Variables
var 0..10: milk;
var 0..10: veg;

var 0..30: total_cost;

% Constraints
constraint calcium_milk * milk + calcium_veg * veg >= min_calcium;
constraint iron_milk * milk + iron_veg * veg >= min_iron;

constraint total_cost = cost_milk * milk + cost_veg * veg;

% Objective
solve minimize total_cost;