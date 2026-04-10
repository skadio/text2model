% Parameters
% Number of food items
int: nFoods = 5;

% Food names (for readability in output)
array[1..nFoods] of string: foodName =
  ["Steak", "Rice", "Chicken", "IcebergLettuce", "Almonds"];

% Nutrition and cost per unit of each food item
array[1..nFoods] of int: protein  = [20, 6, 17, 1, 10];
array[1..nFoods] of int: carbs    = [12, 29, 26, 8, 2];
array[1..nFoods] of int: calories = [167, 275, 112, 148, 286];
array[1..nFoods] of int: cost     = [7, 8, 2, 8, 2];

% Minimum daily requirements
int: minProtein  = 83;
int: minCarbs    = 128;
int: minCalories = 1686;

% Safe upper bound on units of each food item (keeps decision variables bounded)
int: maxUnits =
  max([
    (minProtein  + min(protein)  - 1) div min(protein),
    (minCarbs    + min(carbs)    - 1) div min(carbs),
    (minCalories + min(calories) - 1) div min(calories)
  ]);

% Variables
% x[i] = number of units of food i chosen (non-negative integer)
array[1..nFoods] of var 0..maxUnits: x;

% Total cost (bounded for reporting)
var 0..(maxUnits * sum(cost)): totalCost;

% Constraints
% Cost aggregation: compute total cost from chosen food units
constraint totalCost = sum(i in 1..nFoods)(cost[i] * x[i]);

% Minimum protein requirement
constraint sum(i in 1..nFoods)(protein[i] * x[i]) >= minProtein;

% Minimum carbohydrate requirement
constraint sum(i in 1..nFoods)(carbs[i] * x[i]) >= minCarbs;

% Minimum calorie requirement
constraint sum(i in 1..nFoods)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;

output [
  "minimum_cost=", show(totalCost), "\n",
  "x=", show(x), "\n"
];