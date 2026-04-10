% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Food indices: 1=Chicken, 2=Rice, 3=Broccoli, 4=Eggs
array[FOODS] of int: protein = [17, 20, 3, 18];
array[FOODS] of int: carbs   = [ 6, 13,25, 20];
array[FOODS] of int: calories= [94, 74,73,119];
array[FOODS] of int: cost    = [ 7, 10, 9,  2];

int: reqProtein = 84;
int: reqCarbs   = 117;
int: reqCalories= 1554;

% Variables
array[FOODS] of var 0..50: x;  % number of servings/units of each food
var 0..100000: totalCost;

% Constraints
constraint sum(f in FOODS)(protein[f] * x[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= reqCarbs;
constraint sum(f in FOODS)(calories[f]* x[f]) >= reqCalories;

constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize totalCost;