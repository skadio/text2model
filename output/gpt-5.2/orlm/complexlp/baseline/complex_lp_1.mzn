% Diet / meal planning optimization problem
% Minimize total cost while meeting minimum nutrient requirements.

int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [19, 4, 3, 8];
array[FOODS] of int: carbs   = [9, 16, 11, 7];
array[FOODS] of int: calories= [83, 166, 71, 56];
array[FOODS] of int: cost    = [7, 7, 10, 2];

int: reqProtein  = 84;
int: reqCarbs    = 132;
int: reqCalories = 1990;

% Upper bounds large enough to cover requirements
array[FOODS] of int: ub = [
  (reqProtein + protein[1] - 1) div protein[1] + 50,
  (reqCalories + calories[2] - 1) div calories[2] + 50,
  (reqCarbs + carbs[3] - 1) div carbs[3] + 50,
  (reqProtein + protein[4] - 1) div protein[4] + 50
];

array[FOODS] of var 0..max(ub): x; % number of units purchased of each food

constraint sum(f in FOODS)(protein[f] * x[f])  >= reqProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f])  >= reqCarbs;
constraint sum(f in FOODS)(calories[f]* x[f])  >= reqCalories;

var int: totalCost = sum(f in FOODS)(cost[f] * x[f]);

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "Total protein  = ", show(sum(f in FOODS)(protein[f]  * x[f])), "\n",
  "Total carbs    = ", show(sum(f in FOODS)(carbs[f]    * x[f])), "\n",
  "Total calories = ", show(sum(f in FOODS)(calories[f] * x[f])), "\n",
  "Minimal cost   = $", show(totalCost), "\n"
];