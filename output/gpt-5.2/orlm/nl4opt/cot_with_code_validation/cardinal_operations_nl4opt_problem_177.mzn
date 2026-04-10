% Parameters
int: canoe_capacity = 10;
int: diesel_capacity = 15;
int: min_fish = 1000;
int: canoe_to_diesel_ratio = 3;

% Variables
var 0..(min_fish div canoe_capacity + 1): canoes;
var 0..(min_fish div diesel_capacity + 1): diesel;

% Constraints
constraint canoe_capacity * canoes + diesel_capacity * diesel >= min_fish;
constraint canoes >= canoe_to_diesel_ratio * diesel;

% Objective
solve minimize canoes + diesel;