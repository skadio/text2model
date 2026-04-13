% Parameters
int: nFoods = 8;                               % number of available foods
set of int: FOODS = 1..nFoods;                 % index set for foods

array[FOODS] of string: foodName =             % names of foods (for readability)
  ["Chicken","Rice","Eggs","Beans","Spinach","Corn","Beef","Broccoli"];

array[FOODS] of int: protein =                 % grams of protein per unit
  [5, 8, 18, 16, 3, 3, 6, 17];

array[FOODS] of int: carbs =                   % grams of carbohydrates per unit
  [15, 17, 20, 15, 28, 19, 24, 9];

array[FOODS] of int: calories =                % calories per unit
  [162, 282, 234, 85, 194, 153, 167, 192];

array[FOODS] of int: cost =                    % cost per unit (dollars)
  [8, 4, 1, 4, 7, 2, 9, 3];

int: minProtein = 68;                          % minimum weekly protein requirement
int: minCarbs   = 189;                         % minimum weekly carbohydrate requirement
int: minCalories = 1840;                       % minimum weekly calorie requirement


% Variables
array[FOODS] of var int: x;                    % number of units chosen of each food (>= 0)
var int: totalCost;                            % total cost to minimize


% Constraints
% Non-negative quantities (integer units)
constraint forall(i in FOODS) (x[i] >= 0);

% Define total cost
constraint totalCost = sum(i in FOODS) (cost[i] * x[i]);

% Nutritional requirement constraints (meet or exceed weekly minimums)
constraint sum(i in FOODS) (protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS) (carbs[i] * x[i]) >= minCarbs;
constraint sum(i in FOODS) (calories[i] * x[i]) >= minCalories;


% Objective
solve minimize totalCost;