% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [4, 1, 9, 4];

array[FOODS] of int: protein = [20, 7, 1, 10];
array[FOODS] of int: carbs   = [2, 3, 26, 1];
array[FOODS] of int: calories= [68, 143, 52, 69];

int: minProtein  = 71;
int: minCarbs    = 141;
int: minCalories = 1839;

int: maxUnits = max(
  max( (minProtein  + min(protein)  - 1) div min(protein),
       (minCarbs    + min(carbs)    - 1) div min(carbs)),
  (minCalories + min(calories) - 1) div min(calories)
);

% Variables
array[FOODS] of var 0..maxUnits: x; % units of each food
var 0..(maxUnits * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= minCalories;

% Objective
solve minimize total_cost;