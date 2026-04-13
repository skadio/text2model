int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Bread","Milk","Fish","Potato"];

array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7, 10, 0, 30];
array[FOODS] of int: calories= [130,120,150,70];
array[FOODS] of int: cost    = [3, 4, 8, 2];

int: reqProtein  = 40;
int: reqCarbs    = 50;
int: reqCalories = 450;

% Quantities of each food (allow fractional servings, since typical diet problems allow this)
array[FOODS] of var float: x;

constraint forall(i in FOODS) (x[i] >= 0.0);

constraint sum(i in FOODS) (protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS) (carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS) (calories[i] * x[i]) >= reqCalories;

var float: totalCost = sum(i in FOODS) (cost[i] * x[i]);

solve minimize totalCost;

output [
  "Total cost (exact) = ", show(totalCost), "\n",
  "Total cost (rounded to nearest dollar) = ", show(round(totalCost)), "\n",
  "Quantities:\n"
] ++
[
  name[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
];