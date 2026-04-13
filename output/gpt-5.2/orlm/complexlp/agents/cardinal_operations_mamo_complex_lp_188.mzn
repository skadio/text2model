% Parameters
% Food items (fixed set embedded from the problem statement)
enum Food = {Bread, Milk, Fish, Potato};

% Nutritional content per unit of food
array[Food] of int: protein_g = [4, 6, 20, 1];
array[Food] of int: carbs_g   = [7, 10, 0, 30];
array[Food] of int: calories  = [130, 120, 150, 70];
array[Food] of int: cost_dol  = [3, 4, 8, 2];

% Minimum daily requirements
int: min_protein_g = 40;
int: min_carbs_g   = 50;
int: min_calories  = 450;

% Variables
% Number of units of each food to consume (nonnegative integers)
array[Food] of var 0..100: qty; % upper bound chosen sufficiently large for feasibility

% Total cost (dollars)
var 0..10000: total_cost;

% Constraints
% Link total_cost to chosen quantities and per-unit costs
constraint
  total_cost = sum(f in Food)(cost_dol[f] * qty[f]);

% Meet minimum protein requirement
constraint
  sum(f in Food)(protein_g[f] * qty[f]) >= min_protein_g;

% Meet minimum carbohydrate requirement
constraint
  sum(f in Food)(carbs_g[f] * qty[f]) >= min_carbs_g;

% Meet minimum calorie requirement
constraint
  sum(f in Food)(calories[f] * qty[f]) >= min_calories;

% Objective
solve minimize total_cost;