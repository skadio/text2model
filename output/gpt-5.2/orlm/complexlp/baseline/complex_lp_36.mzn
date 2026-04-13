int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [4, 1, 9, 4];
array[FOODS] of int: protein = [20, 7, 1, 10];
array[FOODS] of int: carbs   = [2, 3, 26, 1];
array[FOODS] of int: calories= [68, 143, 52, 69];

int: reqProtein = 71;
int: reqCarbs = 141;
int: reqCalories = 1839;

% Upper bounds sufficient for feasibility
array[FOODS] of int: ub = [
  (reqProtein div protein[1]) + 1,
  (reqCalories div calories[2]) + 1,
  (reqCarbs div carbs[3]) + 1,
  (reqProtein div protein[4]) + 1
];

array[FOODS] of var 0..max(ub): x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [ show(total_cost) ];