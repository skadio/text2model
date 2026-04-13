% Parameters
% Number of foods
int: nFoods = 4;

% Index set of foods
set of int: FOODS = 1..nFoods;

% Cost per unit of each food (in cents): brownie, choc ice cream, cola, cheesecake
array[FOODS] of int: cost_cents = [50, 20, 30, 80];

% Nutrition per unit of each food
array[FOODS] of int: calories     = [400, 200, 150, 500];
array[FOODS] of int: chocolate_oz = [  3,   2,   0,   0];
array[FOODS] of int: sugar_oz     = [  2,   2,   4,   4];
array[FOODS] of int: fat_oz       = [  2,   4,   1,   5];

% Minimum daily requirements
int: min_calories     = 500;
int: min_chocolate_oz = 6;
int: min_sugar_oz     = 10;
int: min_fat_oz       = 8;

% A safe upper bound on servings (integer) to keep decision variables bounded.
int: maxServings = 20;

% Variables
% Servings of each food consumed (integer, nonnegative)
array[FOODS] of var 0..maxServings: servings;

% Total daily cost (in cents)
var 0..(maxServings * sum(cost_cents)): total_cost_cents;

% Constraints
% Link total cost to chosen servings
constraint
  total_cost_cents = sum(f in FOODS)(cost_cents[f] * servings[f]);

% Meet minimum calorie requirement
constraint
  sum(f in FOODS)(calories[f] * servings[f]) >= min_calories;

% Meet minimum chocolate requirement (oz)
constraint
  sum(f in FOODS)(chocolate_oz[f] * servings[f]) >= min_chocolate_oz;

% Meet minimum sugar requirement (oz)
constraint
  sum(f in FOODS)(sugar_oz[f] * servings[f]) >= min_sugar_oz;

% Meet minimum fat requirement (oz)
constraint
  sum(f in FOODS)(fat_oz[f] * servings[f]) >= min_fat_oz;

% Objective
solve minimize total_cost_cents;