% Parameters
int: nFoods = 5;                          % number of food items
set of int: FOODS = 1..nFoods;            % food index set

array[FOODS] of string: foodName =        % names of foods (for readability)
  ["Steak","Apples","Eggs","Chicken","Tofu"];

array[FOODS] of int: cost =               % cost per unit of food
  [6, 1, 1, 3, 1];

array[FOODS] of int: protein =            % grams protein per unit
  [1, 7, 6, 20, 8];

array[FOODS] of int: carbs =              % grams carbohydrates per unit
  [3, 22, 18, 6, 4];

array[FOODS] of int: calories =           % calories per unit
  [210, 96, 189, 132, 75];

int: minProtein = 87;                     % required minimum protein
int: minCarbs = 135;                      % required minimum carbohydrates
int: minCalories = 1926;                  % required minimum calories

% A safe upper bound on servings to ensure bounded decision variables
% (enough to meet calories using the least calorie-dense item)
int: maxServings = (minCalories div min(calories)) + 1;


% Variables
array[FOODS] of var 0..maxServings: servings;           % number of units chosen of each food
var 0..(maxServings * sum(cost)): totalCost;            % total cost (objective)
var 0..(maxServings * sum(protein)): totalProtein;      % total protein consumed
var 0..(maxServings * sum(carbs)): totalCarbs;          % total carbs consumed
var 0..(maxServings * sum(calories)): totalCals;        % total calories consumed


% Constraints
% Link totals to chosen servings (linear aggregation)
constraint
  totalCost = sum(f in FOODS)(servings[f] * cost[f]);

constraint
  totalProtein = sum(f in FOODS)(servings[f] * protein[f]);

constraint
  totalCarbs = sum(f in FOODS)(servings[f] * carbs[f]);

constraint
  totalCals = sum(f in FOODS)(servings[f] * calories[f]);

% Nutritional minimum requirements
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCals >= minCalories;


% Objective
solve minimize totalCost;