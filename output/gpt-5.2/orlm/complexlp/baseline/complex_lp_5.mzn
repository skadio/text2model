int: n = 9;
set of int: FOODS = 1..n;

array[FOODS] of string: name = ["Chicken","Rice","Apples","Steak","Lentils","Fish","Tofu","Cheese","Bread"];

array[FOODS] of int: protein = [15, 1, 1, 6, 3, 17, 18, 12, 2];
array[FOODS] of int: carbs   = [18,25,21, 3, 7, 13, 27, 17,30];
array[FOODS] of int: calories= [300,267,266,119,166,129,216, 76,258];
array[FOODS] of int: cost    = [  4,  2,  5, 10,  2,  8, 10,  9, 4];

int: minProtein = 90;
int: minCarbs   = 105;
int: minCalories= 1805;

% Upper bound: need at most this many units if using the best protein-per-unit item (Tofu: 18g)
int: maxUnits = max(ceil(int2float(minProtein) / 1.0), ceil(int2float(minCarbs) / 1.0), ceil(int2float(minCalories) / 1.0));
% Use a safe bound derived from calories (min calories per unit is 76 => at most 1805/76 ~= 24) plus slack
int: UB = 60;

array[FOODS] of var 0..UB: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [show(total_cost)];