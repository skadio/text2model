% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

% Food names (for readability in output)
array[FOODS] of string: foodName =
  ["Chicken", "Rice", "Eggs", "Broccoli", "Lentils", "Apples"];

% Cost per unit of each food
array[FOODS] of int: cost =
  [1, 7, 4, 3, 1, 2];

% Nutrients per unit of each food
array[FOODS] of int: protein =
  [18, 14, 18, 7, 15, 8];

array[FOODS] of int: carbs =
  [5, 13, 4, 15, 17, 13];

array[FOODS] of int: calories =
  [202, 234, 220, 247, 88, 77];

% Minimum required totals
int: minProtein  = 70;
int: minCarbs    = 187;
int: minCalories = 2181;


% Variables
% Number of units of each food to include in the meal plan (nonnegative integers)
array[FOODS] of var int: x;

% Totals (decision-dependent)
var int: totalCost;
var int: totalProtein;
var int: totalCarbs;
var int: totalCalories;


% Constraints
% ----------------------------
% Domain constraints (nonnegativity)
% ----------------------------
constraint
  forall(i in FOODS) (
    x[i] >= 0
  );

% ----------------------------
% Linking constraints: compute totals from chosen food units
% ----------------------------
constraint
  totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint
  totalProtein = sum(i in FOODS)(protein[i] * x[i]);

constraint
  totalCarbs = sum(i in FOODS)(carbs[i] * x[i]);

constraint
  totalCalories = sum(i in FOODS)(calories[i] * x[i]);

% ----------------------------
% Nutritional minimum requirements
% ----------------------------
constraint
  totalProtein >= minProtein;

constraint
  totalCarbs >= minCarbs;

constraint
  totalCalories >= minCalories;


% Objective
solve minimize totalCost;

output [
  "Minimum cost = $", show(totalCost), "\n",
  "Food units:\n"
] ++
[
  "  ", foodName[i], ": ", show(x[i]), "\n" | i in FOODS
] ++
[
  "Totals:\n",
  "  Protein  = ", show(totalProtein), "\n",
  "  Carbs    = ", show(totalCarbs), "\n",
  "  Calories = ", show(totalCalories), "\n"
];