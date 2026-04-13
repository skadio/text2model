% Parameters
% Nutrient content per meal (grams)
int: protein_turkey = 20;
int: carbs_turkey   = 30;
int: fat_turkey     = 12;

int: protein_tuna = 18;
int: carbs_tuna   = 25;
int: fat_tuna     = 8;

% Minimum required intake (grams)
int: min_protein = 150;
int: min_carbs   = 200;

% Turkey dinner fraction limit (at most 40% of total meals)
int: max_turkey_pct = 40;

% A safe upper bound on number of meals (enough to satisfy requirements)
int: max_meals = 20;


% Variables
% Number of each meal eaten (non-negative integers)
var 0..max_meals: num_turkey;
var 0..max_meals: num_tuna;

% Total fat intake to be minimized (grams)
var 0..(max_meals * max(fat_turkey, fat_tuna)): total_fat;


% Constraints
% --- Nutrient minimum requirements ---
constraint protein_turkey * num_turkey + protein_tuna * num_tuna >= min_protein;
constraint carbs_turkey   * num_turkey + carbs_tuna   * num_tuna >= min_carbs;

% --- Turkey dinner fraction limit (at most 40% of total meals) ---
% 100 * num_turkey <= max_turkey_pct * (num_turkey + num_tuna)
constraint 100 * num_turkey <= max_turkey_pct * (num_turkey + num_tuna);

% --- Total fat computation (objective linkage) ---
constraint total_fat = fat_turkey * num_turkey + fat_tuna * num_tuna;


% Objective
solve minimize total_fat;

output [
  "num_turkey = ", show(num_turkey), "\n",
  "num_tuna   = ", show(num_tuna), "\n",
  "total_fat  = ", show(total_fat), "\n"
];