% Parameters (with values embedded)
int: protein_turkey = 20;
int: carbs_turkey   = 30;
int: fat_turkey     = 12;

int: protein_tuna = 18;
int: carbs_tuna   = 25;
int: fat_tuna     = 8;

int: min_protein = 150;
int: min_carbs   = 200;

% Variables
var 0..1000: turkey_meals;
var 0..1000: tuna_meals;

% Constraints
constraint protein_turkey * turkey_meals + protein_tuna * tuna_meals >= min_protein;
constraint carbs_turkey * turkey_meals + carbs_tuna * tuna_meals >= min_carbs;

% At most 40% of meals are turkey:
% turkey_meals / (turkey_meals + tuna_meals) <= 0.4
% => 5*turkey_meals <= 2*(turkey_meals + tuna_meals) => 3*turkey_meals <= 2*tuna_meals
constraint 3 * turkey_meals <= 2 * tuna_meals;

% Avoid degenerate zero-meal case (also implied by nutrition constraints, but explicit is fine)
constraint turkey_meals + tuna_meals >= 1;

% Objective
solve minimize fat_turkey * turkey_meals + fat_tuna * tuna_meals;

output [
  "turkey_meals = ", show(turkey_meals), "\n",
  "tuna_meals = ", show(tuna_meals), "\n",
  "total_protein = ", show(protein_turkey * turkey_meals + protein_tuna * tuna_meals), "\n",
  "total_carbs = ", show(carbs_turkey * turkey_meals + carbs_tuna * tuna_meals), "\n",
  "total_fat = ", show(fat_turkey * turkey_meals + fat_tuna * tuna_meals), "\n"
];