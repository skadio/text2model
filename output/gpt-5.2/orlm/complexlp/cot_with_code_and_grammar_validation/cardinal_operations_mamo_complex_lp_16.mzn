% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [10, 4, 13, 15];
array[FOODS] of int: carbs   = [17, 3, 8, 25];
array[FOODS] of int: calories= [159, 126, 230, 112];
array[FOODS] of int: cost    = [5, 5, 8, 3];

int: reqProtein  = 66;
int: reqCarbs    = 101;
int: reqCalories = 1701;

% Safe upper bounds: if we used only the best item for each nutrient, how many units max needed
int: maxByProtein  = (reqProtein  + min(protein) - 1) div min(protein);
int: maxByCarbs    = (reqCarbs    + min(carbs) - 1) div min(carbs);
int: maxByCalories = (reqCalories + min(calories) - 1) div min(calories);
int: maxUnits = max([maxByProtein, maxByCarbs, maxByCalories]);

% Variables
array[FOODS] of var 0..maxUnits: x; % number of units of each food

var 0..(maxUnits * max(cost)): totalCost =
  sum(i in FOODS)(cost[i] * x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;