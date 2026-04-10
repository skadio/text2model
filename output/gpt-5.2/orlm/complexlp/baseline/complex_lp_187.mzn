int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Bread","Milk","Fish","Potato"];

array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7,10,  0,30];
array[FOODS] of int: calories= [130,120,150, 70];
array[FOODS] of int: cost    = [3, 4,  8,  2];

int: reqProtein = 30;
int: reqCarbs   = 40;
int: reqCalories= 400;

% Upper bounds sufficient for optimal solutions
array[FOODS] of int: ub = [
  (reqProtein div protein[1]) + 50,         % Bread
  (reqProtein div protein[2]) + 50,         % Milk
  (reqProtein div protein[3]) + 50,         % Fish
  (reqCarbs   div carbs[4])   + 50          % Potato
];

array[FOODS] of var 0..ub[i]: x;

var int: totalProtein  = sum(i in FOODS)(protein[i] * x[i]);
var int: totalCarbs    = sum(i in FOODS)(carbs[i]   * x[i]);
var int: totalCalories = sum(i in FOODS)(calories[i]* x[i]);
var int: totalCost     = sum(i in FOODS)(cost[i]    * x[i]);

constraint totalProtein  >= reqProtein;
constraint totalCarbs    >= reqCarbs;
constraint totalCalories >= reqCalories;

solve minimize totalCost;

output [
  "Total cost (rounded to nearest dollar): ", show(totalCost), "\n",
  "Totals: protein=", show(totalProtein), "g, carbs=", show(totalCarbs), "g, calories=", show(totalCalories), "\n",
  "Quantities:\n"
] ++
[
  "  " ++ name[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
];