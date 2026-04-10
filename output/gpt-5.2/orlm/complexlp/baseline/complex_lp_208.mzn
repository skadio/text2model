% Diet LP as MIP (integer servings) with all data embedded

int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: food = ["brownie","choc_ice_cream","cola","pineapple_cheesecake"];

% Nutrition per unit
array[FOODS] of int: calories = [400, 200, 150, 500];
array[FOODS] of int: chocolate = [3, 2, 0, 0];   % oz
array[FOODS] of int: sugar    = [2, 2, 4, 4];    % oz
array[FOODS] of int: fat      = [2, 4, 1, 5];    % oz

% Costs in cents
array[FOODS] of int: cost = [50, 20, 30, 80];

% Minimum daily requirements
int: minCalories  = 500;
int: minChocolate = 6;
int: minSugar     = 10;
int: minFat       = 8;

% Decision variables: number of units of each food consumed (integer servings)
int: U = 100; % safe upper bound
array[FOODS] of var 0..U: x;

constraint sum(i in FOODS)(calories[i] * x[i])  >= minCalories;
constraint sum(i in FOODS)(chocolate[i] * x[i]) >= minChocolate;
constraint sum(i in FOODS)(sugar[i] * x[i])     >= minSugar;
constraint sum(i in FOODS)(fat[i] * x[i])       >= minFat;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Optimal integer servings:\n",
  concat([ food[i] ++ " = " ++ show(x[i]) ++ "\n" | i in FOODS ]),
  "Total cost (cents) = ", show(totalCost), "\n",
  "Total cost (dollars) = ", show(totalCost div 100), ".", 
    if (totalCost mod 100) < 10 then "0" else "" endif, show(totalCost mod 100), "\n",
  "Totals:\n",
  "  calories  = ", show(sum(i in FOODS)(calories[i]*x[i])), "\n",
  "  chocolate = ", show(sum(i in FOODS)(chocolate[i]*x[i])), "\n",
  "  sugar     = ", show(sum(i in FOODS)(sugar[i]*x[i])), "\n",
  "  fat       = ", show(sum(i in FOODS)(fat[i]*x[i])), "\n"
];