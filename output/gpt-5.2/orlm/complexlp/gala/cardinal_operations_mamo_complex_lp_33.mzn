% Diet optimization: minimize cost while meeting minimum nutrition requirements.

include "globals.mzn";

% Foods: 1=Chicken, 2=Rice, 3=Beans, 4=Broccoli, 5=Fruit
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [12, 12, 19, 19, 4];
array[FOODS] of int: carbs   = [ 2, 24, 18,  7, 27];
array[FOODS] of int: calories= [186,250,134, 84,104];
array[FOODS] of int: cost    = [ 6,  6,  6,  7,  9];

int: minProtein  = 97;
int: minCarbs    = 163;
int: minCalories = 2217;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bound chosen safely from calorie requirement (worst-case: 84 calories/serving).
int: maxServ = 30;
array[FOODS] of var 0..maxServ: x;

% Nutrition constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);
solve minimize totalCost;

output [
  "Servings (Chicken,Rice,Beans,Broccoli,Fruit) = ", show(x), "\n",
  "Total cost = $", show(totalCost), "\n",
  "Protein = ", show(sum(i in FOODS)(protein[i]*x[i])), "\n",
  "Carbs   = ", show(sum(i in FOODS)(carbs[i]*x[i])), "\n",
  "Calories= ", show(sum(i in FOODS)(calories[i]*x[i])), "\n"
];