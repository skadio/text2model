% Parameters
% Food items (fixed, embedded data)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName =
  ["Chicken", "Broccoli", "Beef", "Rice"];

% Nutrient content per unit of each food
array[FOODS] of int: protein  = [10, 4, 13, 15];
array[FOODS] of int: carbs    = [17, 3,  8, 25];
array[FOODS] of int: calories = [159,126,230,112];

% Cost per unit of each food
array[FOODS] of int: cost = [5, 5, 8, 3];

% Weekly minimum requirements
int: minProtein  = 66;
int: minCarbs    = 101;
int: minCalories = 1701;

% Useful bounds for decision variables (ceil of requirement / best per-unit nutrient)
% (Using max over per-food implied bounds to keep a safe, finite search space.)
int: ubByProtein  = max([ceil(minProtein  / protein[i])  | i in FOODS where protein[i]  > 0]);
int: ubByCarbs    = max([ceil(minCarbs    / carbs[i])    | i in FOODS where carbs[i]    > 0]);
int: ubByCalories = max([ceil(minCalories / calories[i]) | i in FOODS where calories[i] > 0]);
int: ubUnits = max([ubByProtein, ubByCarbs, ubByCalories]);

% Variables
% units[i] = number of units of food i to buy/consume (nonnegative integer)
array[FOODS] of var 0..ubUnits: units;

% Total nutrients achieved (bounded for linear safety)
var 0..(ubUnits * max(protein)):  totalProtein;
var 0..(ubUnits * max(carbs)):    totalCarbs;
var 0..(ubUnits * max(calories)): totalCalories;

% Total cost (bounded)
var 0..(ubUnits * max(cost) * nFoods): totalCost;


% Constraints

% --- Link totals to chosen units (linear definitions) ---
constraint
  totalProtein = sum(i in FOODS)(protein[i] * units[i]);

constraint
  totalCarbs = sum(i in FOODS)(carbs[i] * units[i]);

constraint
  totalCalories = sum(i in FOODS)(calories[i] * units[i]);

constraint
  totalCost = sum(i in FOODS)(cost[i] * units[i]);

% --- Meet weekly minimum nutritional requirements ---
constraint
  totalProtein >= minProtein;

constraint
  totalCarbs >= minCarbs;

constraint
  totalCalories >= minCalories;


% Objective
solve minimize totalCost;