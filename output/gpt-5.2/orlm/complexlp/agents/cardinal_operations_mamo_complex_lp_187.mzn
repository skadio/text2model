% Parameters
% Food types (fixed, embedded data)
enum FOOD = {Bread, Milk, Fish, Potato};

% Nutritional content per unit of each food
array[FOOD] of int: protein_g = [4, 6, 20, 1];
array[FOOD] of int: carbs_g   = [7, 10, 0, 30];
array[FOOD] of int: calories  = [130, 120, 150, 70];
array[FOOD] of int: cost_dol  = [3, 4, 8, 2];

% Minimum daily requirements
int: min_protein_g = 30;
int: min_carbs_g   = 40;
int: min_calories  = 400;

% Variables
% Amount (number of units/servings) of each food to buy/consume
array[FOOD] of var 0..1000: qty;

% Total cost in dollars (linear expression over integer quantities)
var 0..100000: total_cost_dol;

% Rounded total cost (nearest dollar) — kept as a variable for reporting
% (Total cost is already integer, so rounding is identity.)
var 0..100000: rounded_cost_dol;

% Constraints
% --- Link total cost to chosen quantities (linear cost accounting) ---
constraint
  total_cost_dol = sum(f in FOOD)(cost_dol[f] * qty[f]);

% --- Nutritional minimums (meet or exceed daily requirements) ---
constraint
  sum(f in FOOD)(protein_g[f] * qty[f]) >= min_protein_g;

constraint
  sum(f in FOOD)(carbs_g[f] * qty[f]) >= min_carbs_g;

constraint
  sum(f in FOOD)(calories[f] * qty[f]) >= min_calories;

% --- Rounded cost (nearest dollar); since total_cost_dol is integer, it equals its rounding ---
constraint
  rounded_cost_dol = total_cost_dol;

% Objective
solve minimize rounded_cost_dol;