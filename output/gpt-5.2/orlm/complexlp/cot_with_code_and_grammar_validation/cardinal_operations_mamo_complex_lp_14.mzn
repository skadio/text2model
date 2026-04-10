% Parameters
int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName =
  ["Eggs","Grains","Berries","Nuts","Salmon","Vegetables","Rice","Meat"];

array[FOODS] of int: cost = [4,3,2,4,9,3,6,6];
array[FOODS] of int: protein = [2,7,6,16,20,6,6,5];
array[FOODS] of int: carbs = [4,9,18,3,11,27,30,1];
array[FOODS] of int: calories = [282,104,71,116,175,132,251,74];

int: minProtein = 84;
int: minCarbs = 195;
int: minCalories = 1941;

% Variables
% Upper bounds based on minimum requirements and positive nutrient contributions
int: maxUnitsProtein = minProtein;    % since each food has >=1 protein, safe bound
int: maxUnitsCarbs = minCarbs;        % since each food has >=1 carbs, safe bound
int: maxUnitsCalories = minCalories;  % since each food has >=71 calories, safe bound
int: maxUnits = max(maxUnitsProtein, max(maxUnitsCarbs, maxUnitsCalories));

array[FOODS] of var 0..maxUnits: x; % number of units of each food

var 0..(maxUnits * max(cost)): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;