% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: calories = [400, 200, 150, 500];
array[FOODS] of int: chocolate = [3, 2, 0, 0];
array[FOODS] of int: sugar = [2, 2, 4, 4];
array[FOODS] of int: fat = [2, 4, 1, 5];

% costs in cents
array[FOODS] of int: cost = [50, 20, 30, 80];

int: minCalories = 500;
int: minChocolate = 6;
int: minSugar = 10;
int: minFat = 8;

% Variables
% nonnegative amounts of each food (continuous approximation via fixed precision)
int: scale = 100; % 1 unit = 0.01 food-units
array[FOODS] of var 0..100000: x; % scaled quantities

var 0..100000000: totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(calories[f] * x[f]) >= minCalories * scale;
constraint sum(f in FOODS)(chocolate[f] * x[f]) >= minChocolate * scale;
constraint sum(f in FOODS)(sugar[f] * x[f]) >= minSugar * scale;
constraint sum(f in FOODS)(fat[f] * x[f]) >= minFat * scale;

% Objective
solve minimize totalCost;