% Diet / meal planning: minimize cost while meeting nutrient requirements
% Data embedded as requested.

include "globals.mzn";

set of int: FOODS = 1..4;
int: CHICKEN = 1;
int: RICE    = 2;
int: BROCC   = 3;
int: EGGS    = 4;

array[FOODS] of int: protein = [17, 20, 3, 18];
array[FOODS] of int: carbs   = [6,  13, 25, 20];
array[FOODS] of int: cal     = [94, 74, 73, 119];
array[FOODS] of int: cost    = [7,  10, 9,  2];

int: reqProtein = 84;
int: reqCarbs   = 117;
int: reqCal     = 1554;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bounds chosen safely based on requirements and minimum per-serving contribution.
array[FOODS] of var 0..200: x;

var int: totalProtein = sum(f in FOODS)(protein[f] * x[f]);
var int: totalCarbs   = sum(f in FOODS)(carbs[f] * x[f]);
var int: totalCal     = sum(f in FOODS)(cal[f] * x[f]);

constraint totalProtein >= reqProtein;
constraint totalCarbs   >= reqCarbs;
constraint totalCal     >= reqCal;

var int: totalCost = sum(f in FOODS)(cost[f] * x[f]);

solve minimize totalCost;

output [
  "Servings (Chicken,Rice,Broccoli,Eggs) = ", show([x[CHICKEN], x[RICE], x[BROCC], x[EGGS]]), "\n",
  "Total protein = ", show(totalProtein), "\n",
  "Total carbs   = ", show(totalCarbs), "\n",
  "Total calories= ", show(totalCal), "\n",
  "Minimal cost  = ", show(totalCost), "\n"
];