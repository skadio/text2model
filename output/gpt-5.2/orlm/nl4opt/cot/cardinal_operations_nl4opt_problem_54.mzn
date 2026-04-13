% Parameters (with values embedded)
int: min_calcium = 100;
int: min_iron = 50;

int: cost_milk = 1;
int: cost_veg  = 2;

int: calcium_milk = 40;
int: iron_milk    = 25;

int: calcium_veg = 15;
int: iron_veg    = 30;

% Variables
var 0..10: milk;       % number of glasses of milk
var 0..10: vegetables; % number of plates of vegetables

% Constraints
constraint calcium_milk * milk + calcium_veg * vegetables >= min_calcium;
constraint iron_milk * milk + iron_veg * vegetables >= min_iron;

% Objective
var int: total_cost = cost_milk * milk + cost_veg * vegetables;
solve minimize total_cost;