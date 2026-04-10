% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

int: nNutrients = 4;
set of int: NUTS = 1..nNutrients;

% Nutrient indices
int: CAL = 1;
int: CHOC = 2;
int: SUGAR = 3;
int: FAT = 4;

% Data (per unit)
array[FOODS, NUTS] of int: content =
  [| 400, 3, 2, 2   % brownies
   | 200, 2, 2, 4   % chocolate ice cream
   | 150, 0, 4, 1   % cola
   | 500, 0, 4, 5   % pineapple cheesecake
  |];

% Costs in cents per unit
array[FOODS] of int: cost = [50, 20, 30, 80];

% Minimum daily requirements
array[NUTS] of int: req = [500, 6, 10, 8];

% Variables
array[FOODS] of var 0..100: x; % units of each food (upper bound chosen for bounded search)
var int: total_cost;

% Constraints
constraint forall(n in NUTS) (
  sum(f in FOODS)(content[f,n] * x[f]) >= req[n]
);

constraint total_cost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize total_cost;