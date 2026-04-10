% Parameters
int: nFoods = 5;                               % Number of food items
set of int: FOODS = 1..nFoods;                 % Index set for foods

% Nutritional content per unit of each food (aligned by FOODS index)
% Order: 1=Chicken, 2=Rice, 3=Beans, 4=Broccoli, 5=Fruit
array[FOODS] of int: protein  = [12, 12, 19, 19,  4];   % grams protein per unit
array[FOODS] of int: carbs    = [ 2, 24, 18,  7, 27];   % grams carbohydrates per unit
array[FOODS] of int: calories = [186,250,134, 84,104];  % calories per unit
array[FOODS] of int: cost     = [ 6,  6,  6,  7,  9];   % cost per unit ($)

% Minimum required totals
int: minProtein  = 97;                         % minimum grams protein
int: minCarbs    = 163;                        % minimum grams carbs
int: minCalories = 2217;                       % minimum calories

% Safe upper bound for units purchased (based on the most calorie-dense food)
int: maxUnits = ceil(int2float(minCalories) / min([calories[i] | i in FOODS]));

% Variables
array[FOODS] of var 0..maxUnits: x;            % x[i] = units of food i to buy (nonnegative integer)

var int: totalCost;                            % total cost of selected foods
var int: totalProtein;                         % total protein achieved
var int: totalCarbs;                           % total carbs achieved
var int: totalCalories;                        % total calories achieved

% Constraints
% --- Define total nutrient intakes as linear sums of chosen food units ---
constraint
  totalProtein = sum(i in FOODS)(protein[i] * x[i]);

constraint
  totalCarbs = sum(i in FOODS)(carbs[i] * x[i]);

constraint
  totalCalories = sum(i in FOODS)(calories[i] * x[i]);

% --- Define total cost as linear sum of chosen food units ---
constraint
  totalCost = sum(i in FOODS)(cost[i] * x[i]);

% --- Meet minimum dietary requirements ---
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;