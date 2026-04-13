% Parameters
int: nFoods = 5;                          % number of food items
set of int: FOODS = 1..nFoods;            % index set for foods

int: nNutrients = 3;                      % number of nutrients (protein, carbs, calories)
set of int: NUTRIENTS = 1..nNutrients;    % index set for nutrients

int: PROTEIN = 1;
int: CARBS   = 2;
int: CALS    = 3;

array[FOODS] of int: cost = [4, 8, 7, 10, 1];  % cost per unit of each food

% nutrients[food, nutrient] = amount of nutrient provided by 1 unit of food
array[FOODS, NUTRIENTS] of int: nutrients =
  array2d(FOODS, NUTRIENTS,
    [ 18,  6, 142,   % Chicken
      12, 28,  88,   % Rice
      13, 19, 137,   % Broccoli
       5, 16, 141,   % Tofu
      10, 20, 150    % Beans
    ]);

array[NUTRIENTS] of int: minReq = [56, 194, 2012]; % minimum required for each nutrient

% Variables
array[FOODS] of var 0..2012: x;            % units of each food (nonnegative integer)
var 0..(2012 * 10): totalCost;             % total cost (bounded using max cost=10)

% Constraints
% --- Total cost definition ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * x[f]);

% --- Nutritional minimum requirements ---
% Ensure that for each nutrient, the total supplied by chosen foods meets/exceeds the minimum.
constraint
  forall(n in NUTRIENTS) (
    sum(f in FOODS)(nutrients[f, n] * x[f]) >= minReq[n]
  );

% Objective
solve minimize totalCost;