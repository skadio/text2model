% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [2, 18, 2, 18];
array[FOODS] of int: carbs   = [4, 17, 28, 27];
array[FOODS] of int: calories= [218, 290, 298, 158];
array[FOODS] of int: cost    = [3, 6, 1, 10];

int: minProtein  = 86;
int: minCarbs    = 120;
int: minCalories = 2435;

int: maxUnits = max(
  (minProtein  + min(protein)  - 1) div min(protein),
  max(
    (minCarbs    + min(carbs)   - 1) div min(carbs),
    (minCalories + min(calories)- 1) div min(calories)
  )
);

% Variables
array[FOODS] of var 0..maxUnits: x;
var 0..(maxUnits * max(cost)): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;