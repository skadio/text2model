% Diet / nutrition linear optimization model (integer units)

include "globals.mzn";

% Foods: 1=brownie, 2=choc_ice_cream, 3=cola, 4=pineapple_cheesecake
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: calories  = [400, 200, 150, 500];
array[FOODS] of int: chocolate = [  3,   2,   0,   0];  % oz
array[FOODS] of int: sugar     = [  2,   2,   4,   4];  % oz
array[FOODS] of int: fat       = [  2,   4,   1,   5];  % oz

% Costs in cents
array[FOODS] of int: cost = [50, 20, 30, 80];

% Minimum daily requirements
int: minCalories  = 500;
int: minChocolate = 6;
int: minSugar     = 10;
int: minFat       = 8;

% Decision variables: integer number of units of each food
% Safe upper bound: 0..100 (well above what is needed)
array[FOODS] of var 0..100: x;

% Nutritional constraints
constraint sum(i in FOODS)(calories[i]  * x[i]) >= minCalories;
constraint sum(i in FOODS)(chocolate[i] * x[i]) >= minChocolate;
constraint sum(i in FOODS)(sugar[i]     * x[i]) >= minSugar;
constraint sum(i in FOODS)(fat[i]       * x[i]) >= minFat;

% Objective: minimize cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);
solve minimize totalCost;

output [
  "x (brownie, icecream, cola, cheesecake) = ", show(x), "\n",
  "Total cost (cents) = ", show(totalCost), "\n"
];