% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["brownies","choc_ice_cream","cola","pineapple_cheesecake"];

array[FOODS] of int: calories  = [400, 200, 150, 500];
array[FOODS] of int: chocolate = [  3,   2,   0,   0]; % oz
array[FOODS] of int: sugar     = [  2,   2,   4,   4]; % oz
array[FOODS] of int: fat       = [  2,   4,   1,   5]; % oz

% costs in cents
array[FOODS] of int: cost = [50, 20, 30, 80];

int: minCalories  = 500;
int: minChocolate = 6;
int: minSugar     = 10;
int: minFat       = 8;

% Variables
% Allow fractional amounts (LP-style), bounded nonnegative.
array[FOODS] of var 0.0..1000.0: x; % amount of each food (units)

var 0.0..100000.0: totalCost;

% Constraints
constraint sum(f in FOODS)(calories[f]  * x[f]) >= minCalories;
constraint sum(f in FOODS)(chocolate[f] * x[f]) >= minChocolate;
constraint sum(f in FOODS)(sugar[f]     * x[f]) >= minSugar;
constraint sum(f in FOODS)(fat[f]       * x[f]) >= minFat;

constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize totalCost;

output [
  "Minimal cost (cents) = ", show(totalCost), "\n",
  "Amounts:\n"
] ++
[
  foodName[f] ++ " = " ++ show(x[f]) ++ "\n"
  | f in FOODS
];