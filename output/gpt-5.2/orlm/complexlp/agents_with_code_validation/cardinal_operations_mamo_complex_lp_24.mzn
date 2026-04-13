% Parameters
int: nFoods = 6;                               % number of food items
set of int: FOODS = 1..nFoods;                 % index set for foods

% Per-unit nutrient content and cost for each food (in FOODS order:
% 1=Chicken, 2=Rice, 3=Eggs, 4=Broccoli, 5=Lentils, 6=Apples)
array[FOODS] of int: protein  = [18, 14, 18,  7, 15,  8];   % grams protein per unit
array[FOODS] of int: carbs    = [ 5, 13,  4, 15, 17, 13];   % grams carbs per unit
array[FOODS] of int: calories = [202,234,220,247, 88, 77];  % calories per unit
array[FOODS] of int: cost     = [ 1,  7,  4,  3,  1,  2];   % dollars per unit

% Minimum daily requirements
int: minProtein  = 70;
int: minCarbs    = 187;
int: minCalories = 2181;

% Upper bound for quantities (safe loose bound)
int: maxQty = minCalories;                     % valid because each unit has >= 1 calorie

% Variables
array[FOODS] of var 0..maxQty: qty;            % integer units chosen per food
var 0..(maxQty * max(cost)): totalCost;        % total cost to minimize

% Constraints

% Link totalCost to chosen quantities
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Meet minimum protein requirement
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

% Meet minimum carbohydrate requirement
constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

% Meet minimum calorie requirement
constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;