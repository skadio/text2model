% Parameters
int: N = 4;
set of int: FOODS = 1..N;

array[FOODS] of int: calories = [400, 200, 150, 500];
array[FOODS] of int: chocolate = [3, 2, 0, 0];
array[FOODS] of int: sugar = [2, 2, 4, 4];
array[FOODS] of int: fat = [2, 4, 1, 5];

% costs in cents
array[FOODS] of int: cost = [50, 20, 30, 80];

int: min_calories = 500;
int: min_chocolate = 6;
int: min_sugar = 10;
int: min_fat = 8;

% Variables
% units of each food (treated as continuous via scaling by 100 => hundredths of a unit)
int: SCALE = 100;
int: UB = 1000 * SCALE;

array[FOODS] of var 0..UB: x;

% Constraints
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories * SCALE;
constraint sum(i in FOODS)(chocolate[i] * x[i]) >= min_chocolate * SCALE;
constraint sum(i in FOODS)(sugar[i] * x[i]) >= min_sugar * SCALE;
constraint sum(i in FOODS)(fat[i] * x[i]) >= min_fat * SCALE;

% Objective
var int: total_cost_cents_scaled = sum(i in FOODS)(cost[i] * x[i]);
solve minimize total_cost_cents_scaled;