% Parameters
int: canoe_capacity = 10;
int: diesel_capacity = 15;
int: min_fish = 1000;
int: canoe_to_diesel_ratio = 3;

% Variables
var 0..ceil(min_fish / canoe_capacity): canoes;
var 0..ceil(min_fish / diesel_capacity): diesel_boats;

% Constraints
constraint
  canoe_capacity * canoes + diesel_capacity * diesel_boats >= min_fish;

constraint
  canoes >= canoe_to_diesel_ratio * diesel_boats;

% Objective
solve minimize canoes + diesel_boats;