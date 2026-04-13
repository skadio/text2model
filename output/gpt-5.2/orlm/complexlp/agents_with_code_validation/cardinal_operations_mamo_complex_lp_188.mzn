% Parameters
% Food items (fixed, data embedded as requested)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Nutritional values per unit of each food (indexed by FOODS)
array[FOODS] of int: protein_g = [4, 6, 20, 1];       % Bread, Milk, Fish, Potato
array[FOODS] of int: carbs_g   = [7, 10, 0, 30];      % Bread, Milk, Fish, Potato
array[FOODS] of int: calories  = [130, 120, 150, 70]; % Bread, Milk, Fish, Potato
array[FOODS] of int: cost_dol  = [3, 4, 8, 2];        % Bread, Milk, Fish, Potato

% Minimum daily requirements
int: minProtein  = 40;
int: minCarbs    = 50;
int: minCalories = 450;

% A safe upper bound on servings to enable bounded integer variables
% (Using 0..minCalories/min(calories) rounded up -> 0..7)
int: maxServings = 7;

% Variables
array[FOODS] of var 0..maxServings: servings;  % number of servings of each food (integer)

var 0..(maxServings * sum(cost_dol)): totalCost; % total dollar cost (bounded)
var int: roundedCost;                             % total cost rounded to nearest dollar (already int here)

% (Optional) helpful totals (bounded) for use in constraints/inspection
var 0..(maxServings * sum(protein_g)): totalProtein;
var 0..(maxServings * sum(carbs_g)): totalCarbs;
var 0..(maxServings * sum(calories)): totalCalories;

% Constraints
% --- Compute nutrient totals from chosen servings ---
constraint totalProtein  = sum(f in FOODS)(protein_g[f] * servings[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs_g[f]   * servings[f]);
constraint totalCalories = sum(f in FOODS)(calories[f]  * servings[f]);

% --- Compute total cost from chosen servings ---
constraint totalCost = sum(f in FOODS)(cost_dol[f] * servings[f]);

% --- Minimum daily nutritional requirements ---
constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

% --- Rounding (cost is already integer dollars, so "rounded" equals total) ---
constraint roundedCost = totalCost;

% Objective
solve minimize roundedCost;