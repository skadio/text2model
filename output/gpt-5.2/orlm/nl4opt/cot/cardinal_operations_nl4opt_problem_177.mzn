% Parameters (with values embedded)
int: canoe_capacity = 10;
int: diesel_capacity = 15;
int: min_fish = 1000;
int: ratio = 3;

% Variables
var 0..100: diesel_boats;
var 0..300: canoes;

% Constraints
constraint canoes >= ratio * diesel_boats;
constraint canoe_capacity * canoes + diesel_capacity * diesel_boats >= min_fish;

% Objective
solve minimize canoes + diesel_boats;