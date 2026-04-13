% Parameters
int: nFoods = 7;                          % number of food options
set of int: FOODS = 1..nFoods;            % index set for foods

array[FOODS] of string: foodName =        % food names (for readability)
  ["Chicken","Tuna","Eggs","Beef","Rice","Apples","Bread"];

array[FOODS] of int: protein =            % grams of protein per unit
  [18, 12, 7, 17, 3, 4, 4];

array[FOODS] of int: carbs =              % grams of carbohydrates per unit
  [23, 30, 16, 26, 30, 6, 23];

array[FOODS] of int: calories =           % calories per unit
  [217, 182, 79, 295, 264, 160, 141];

array[FOODS] of int: price =              % cost per unit ($)
  [3, 10, 10, 7, 4, 6, 5];

int: reqProtein = 59;                     % weekly protein target (g)
int: reqCarbs = 160;                      % weekly carbohydrate target (g)
int: reqCalories = 1809;                  % weekly calorie target


% Variables
array[FOODS] of var 0..1000: servings;    % number of units of each food (nonnegative integer)

var 0..1000000: totalCost;                % total weekly cost ($)
var 0..1000000: totalProtein;             % total protein (g)
var 0..1000000: totalCarbs;               % total carbs (g)
var 0..1000000: totalCalories;            % total calories


% Constraints

% --- Nutrient aggregation (link totals to chosen servings) ---
constraint
  totalProtein = sum(f in FOODS)(protein[f] * servings[f]);

constraint
  totalCarbs = sum(f in FOODS)(carbs[f] * servings[f]);

constraint
  totalCalories = sum(f in FOODS)(calories[f] * servings[f]);

% --- Cost aggregation (link total cost to chosen servings) ---
constraint
  totalCost = sum(f in FOODS)(price[f] * servings[f]);

% --- Weekly nutritional requirements (meet or exceed targets) ---
constraint
  totalProtein >= reqProtein;

constraint
  totalCarbs >= reqCarbs;

constraint
  totalCalories >= reqCalories;


% Objective
solve minimize totalCost;