% Parameters
int: profit_A = 30;
int: profit_B = 10;

int: max_hours = 40;
int: hours_per_kg_A = 6;
int: hours_per_kg_B = 3;

int: min_B_per_A = 3;

int: storage_ratio_A_to_B = 4;
int: max_storage_A_kg = 4;

% Variables
var 0..max_storage_A_kg: xA;                 % kg of product A produced
var 0..(max_hours div hours_per_kg_B): xB;   % kg of product B produced

% Constraints
constraint
  hours_per_kg_A * xA + hours_per_kg_B * xB <= max_hours;

constraint
  xB >= min_B_per_A * xA;

constraint
  xA <= max_storage_A_kg;

constraint
  storage_ratio_A_to_B * xA <= storage_ratio_A_to_B * max_storage_A_kg;

% Objective
solve maximize profit_A * xA + profit_B * xB;