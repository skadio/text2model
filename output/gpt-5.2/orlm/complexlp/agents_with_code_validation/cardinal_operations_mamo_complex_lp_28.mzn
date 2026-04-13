% Parameters
int: nFoods = 9;                         % number of available food items
set of int: FOODS = 1..nFoods;           % index set for foods

array[FOODS] of string: foodName =       % food names (for readability)
  ["Beef","Pasta","Broccoli","Chicken","Apple","Pork","Lentils","Eggs","Cheese"];

array[FOODS] of int: cost =              % cost per unit of each food ($)
  [5, 6, 5, 4, 1, 6, 1, 2, 7];

array[FOODS] of int: protein =           % grams of protein per unit
  [18, 2, 7, 20, 5, 13, 15, 20, 9];

array[FOODS] of int: carbs =             % grams of carbohydrates per unit
  [13, 25, 30, 16, 6, 9, 18, 18, 14];

array[FOODS] of int: calories =          % calories per unit
  [233, 251, 191, 231, 111, 275, 99, 210, 74];

int: minProtein  = 68;                   % minimum daily protein requirement
int: minCarbs    = 151;                  % minimum daily carbohydrate requirement
int: minCalories = 1900;                 % minimum daily calorie requirement

% Upper bound on servings to keep the model bounded (loose but safe)
% ceil(1900 / 74) = 26 using smallest calories-per-unit (Cheese)
int: maxServings = 26;

% Variables
array[FOODS] of var 0..maxServings: servings;  % integer servings of each food

var 0..sum(f in FOODS)(cost[f] * maxServings): totalCost;             % total daily cost ($)
var 0..sum(f in FOODS)(protein[f] * maxServings): totalProtein;       % total protein (g)
var 0..sum(f in FOODS)(carbs[f] * maxServings): totalCarbs;           % total carbs (g)
var 0..sum(f in FOODS)(calories[f] * maxServings): totalCalories;     % total calories

% Constraints
% Link aggregate totals to chosen servings (linear definitions)
constraint totalCost     = sum(f in FOODS)(cost[f]     * servings[f]);
constraint totalProtein  = sum(f in FOODS)(protein[f]  * servings[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs[f]    * servings[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * servings[f]);

% Meet minimum daily nutrition requirements
constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;