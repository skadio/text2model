% Parameters
int: nFoods = 7;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName =
  ["Chicken","Tuna","Eggs","Beef","Rice","Apples","Bread"];

array[FOODS] of int: protein  = [18,12,7,17,3,4,4];
array[FOODS] of int: carbs    = [23,30,16,26,30,6,23];
array[FOODS] of int: calories = [217,182,79,295,264,160,141];
array[FOODS] of int: price    = [3,10,10,7,4,6,5];

int: targetProtein  = 59;
int: targetCarbs    = 160;
int: targetCalories = 1809;

% Safe upper bounds per food (can't need more than target when all coeffs are positive)
array[FOODS] of int: maxQtyProtein  = [targetProtein  div protein[i]  + 1 | i in FOODS];
array[FOODS] of int: maxQtyCarbs    = [targetCarbs    div carbs[i]    + 1 | i in FOODS];
array[FOODS] of int: maxQtyCalories = [targetCalories div calories[i] + 1 | i in FOODS];

% Use the maximum of the three bounds to ensure feasibility (fixes wrong min-bound idea)
array[FOODS] of int: maxQty = [max([maxQtyProtein[i], maxQtyCarbs[i], maxQtyCalories[i]]) | i in FOODS];

% Variables
array[FOODS] of var 0..maxQty[i]: qty;

var 0..sum(i in FOODS)(price[i] * maxQty[i]): totalCost;
var 0..sum(i in FOODS)(protein[i]  * maxQty[i]):  totalProtein;
var 0..sum(i in FOODS)(carbs[i]    * maxQty[i]):  totalCarbs;
var 0..sum(i in FOODS)(calories[i] * maxQty[i]):  totalCalories;

% Constraints
constraint totalCost     = sum(i in FOODS)(price[i]    * qty[i]);
constraint totalProtein  = sum(i in FOODS)(protein[i]  * qty[i]);
constraint totalCarbs    = sum(i in FOODS)(carbs[i]    * qty[i]);
constraint totalCalories = sum(i in FOODS)(calories[i] * qty[i]);

constraint totalProtein  >= targetProtein;
constraint totalCarbs    >= targetCarbs;
constraint totalCalories >= targetCalories;

% Objective
solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Quantities:\n"
] ++
[
  foodName[i] ++ ": " ++ show(qty[i]) ++ "\n"
  | i in FOODS
] ++
[
  "Totals: protein=", show(totalProtein),
  " carbs=", show(totalCarbs),
  " calories=", show(totalCalories), "\n"
];