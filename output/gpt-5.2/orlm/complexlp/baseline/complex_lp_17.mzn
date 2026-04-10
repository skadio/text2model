int: n = 5;
set of int: FOODS = 1..n;

array[FOODS] of string: name = ["Lentils","Rice","Chicken","Beef","Tofu"];

array[FOODS] of int: cost = [7,6,6,10,2];
array[FOODS] of int: protein = [13,2,7,18,12];
array[FOODS] of int: carbs   = [21,30,13,8,28];
array[FOODS] of int: calories= [284,55,276,204,160];

int: req_protein = 79;
int: req_carbs = 170;
int: req_calories = 1699;

% Safe upper bound: worst-case cost efficiency is Beef at 10 dollars per unit,
% so buying 10*req_protein units is always enough to meet protein (and other constraints can be met too).
int: UB = req_calories;

array[FOODS] of var 0..UB: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [ show(total_cost) ];