% Parameters
int: nFoods = 8;                              % number of food items
set of int: FOODS = 1..nFoods;                % index set for foods

array[FOODS] of int: cost =                   % cost per unit of each food
  [4, 3, 2, 4, 9, 3, 6, 6];

array[FOODS] of int: protein =                % grams of protein per unit
  [2, 7, 6, 16, 20, 6, 6, 5];

array[FOODS] of int: carbs =                  % grams of carbohydrates per unit
  [4, 9, 18, 3, 11, 27, 30, 1];

array[FOODS] of int: calories =               % calories per unit
  [282, 104, 71, 116, 175, 132, 251, 74];

int: minProtein = 84;                         % minimum required protein
int: minCarbs = 195;                          % minimum required carbohydrates
int: minCalories = 1941;                      % minimum required calories

% A safe upper bound on each food quantity based on the tightest requirement.
% (ceil(minProtein/min protein), ceil(minCarbs/min carbs), ceil(minCalories/min calories))
int: maxQty =
  max( max( ceil(minProtein / 2.0), ceil(minCarbs / 1.0) ),
       ceil(minCalories / 71.0) );            % worst-case among foods -> safe bound

% Variables
array[FOODS] of var 0..maxQty: qty;            % units chosen of each food (nonnegative integer)
var 0..(maxQty * sum(cost)): totalCost;        % total cost (bounded)

% Constraints

% Total cost definition (link totalCost to chosen quantities)
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Minimum protein requirement
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

% Minimum carbohydrates requirement
constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

% Minimum calories requirement
constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;