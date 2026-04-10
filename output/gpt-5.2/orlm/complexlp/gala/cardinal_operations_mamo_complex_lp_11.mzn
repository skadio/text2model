% Diet / meal planning: minimize cost while meeting nutrition minimums.
% Data is embedded as required.

include "globals.mzn";

enum Food = {Chicken, Pasta, Rice, Beans, Cheese};
int: nFoods = card(Food);

array[Food] of int: protein = [5, 3, 11, 10, 4];
array[Food] of int: carbs   = [13, 23, 27, 27, 18];
array[Food] of int: calories= [121, 274, 251, 259, 199];
array[Food] of int: cost    = [7, 10, 7, 9, 7];

int: minProtein  = 60;
int: minCarbs    = 146;
int: minCalories = 1727;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bounds chosen safely: enough to reach calorie target even with lowest-calorie item.
array[Food] of var 0..14: x;

var int: totalProtein  = sum(f in Food)(protein[f] * x[f]);
var int: totalCarbs    = sum(f in Food)(carbs[f]   * x[f]);
var int: totalCalories = sum(f in Food)(calories[f]* x[f]);
var int: totalCost     = sum(f in Food)(cost[f]    * x[f]);

constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

solve minimize totalCost;

output [
  "Servings x = ", show(x), "\n",
  "Total protein  = ", show(totalProtein),  "\n",
  "Total carbs    = ", show(totalCarbs),    "\n",
  "Total calories = ", show(totalCalories), "\n",
  "Total cost     = ", show(totalCost),     "\n"
];