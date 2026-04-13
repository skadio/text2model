% Diet optimization (integer quantities of each food)
include "globals.mzn";

% Foods: 1=Chicken, 2=Rice, 3=Tuna, 4=Beef, 5=Corn, 6=Whey
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Chicken","Rice","Tuna","Beef","Corn","Whey"];

array[FOODS] of int: protein = [13, 1, 17, 15, 2, 15];
array[FOODS] of int: carbs   = [27, 1,  2, 18,19, 11];
array[FOODS] of int: calories= [81,137,53,126,117,277];
array[FOODS] of int: cost    = [ 1,  9, 2,  9,  4,  6];

int: minProtein = 58;
int: minCarbs   = 148;
int: minCals    = 2454;

% Decision: number of servings/units of each food (nonnegative integers)
% Upper bound chosen large enough for feasibility; calories target drives needs.
int: UB = 1000;
array[FOODS] of var 0..UB: x;

% Nutrient totals
var 0..(UB * max(protein)):  totalProtein = sum(i in FOODS)(protein[i] * x[i]);
var 0..(UB * max(carbs)):    totalCarbs   = sum(i in FOODS)(carbs[i]   * x[i]);
var 0..(UB * max(calories)): totalCals    = sum(i in FOODS)(calories[i]* x[i]);

% Meet minimum requirements
constraint totalProtein >= minProtein;
constraint totalCarbs   >= minCarbs;
constraint totalCals    >= minCals;

% Objective: minimize total cost
var 0..(UB * max(cost)): totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "TotalCost = $", show(totalCost), "\n",
  "Totals: protein=", show(totalProtein), " carbs=", show(totalCarbs), " calories=", show(totalCals), "\n",
  "Servings:\n",
  concat([ name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS ])
];