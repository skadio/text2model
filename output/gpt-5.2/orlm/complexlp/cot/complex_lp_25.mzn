% Parameters (with values embedded)
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Rice","Tuna","Beef","Corn","Whey"];

array[FOODS] of int: protein = [13, 1, 17, 15, 2, 15];
array[FOODS] of int: carbs   = [27, 1,  2, 18,19, 11];
array[FOODS] of int: calories= [81,137,53,126,117,277];
array[FOODS] of int: cost    = [1,  9,  2,  9,  4,  6];

int: reqProtein  = 58;
int: reqCarbs    = 148;
int: reqCalories = 2454;

% Variables
% x[i] = number of servings/units of food i to buy (nonnegative integer)
array[FOODS] of var 0..1000: x;

var 0..1000000: totalCost;
var 0..1000000: totalProtein;
var 0..1000000: totalCarbs;
var 0..10000000: totalCalories;

% Constraints
constraint totalCost     = sum(i in FOODS)(cost[i] * x[i]);
constraint totalProtein  = sum(i in FOODS)(protein[i] * x[i]);
constraint totalCarbs    = sum(i in FOODS)(carbs[i] * x[i]);
constraint totalCalories = sum(i in FOODS)(calories[i] * x[i]);

constraint totalProtein  >= reqProtein;
constraint totalCarbs    >= reqCarbs;
constraint totalCalories >= reqCalories;

% Objective
solve minimize totalCost;

output [
  "Total cost = $", show(totalCost), "\n",
  "Total protein = ", show(totalProtein), " g\n",
  "Total carbs = ", show(totalCarbs), " g\n",
  "Total calories = ", show(totalCalories), "\n\n",
  "Food quantities:\n"
] ++
[
  foodName[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
];