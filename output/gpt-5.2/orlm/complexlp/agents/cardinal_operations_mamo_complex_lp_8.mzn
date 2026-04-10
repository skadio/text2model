% Parameters
int: nFoods = 9;                                  % number of food items

set of int: FOODS = 1..nFoods;                    % index set for foods
set of int: NUTRIENTS = 1..3;                     % 1=protein, 2=carbs, 3=calories

array[FOODS] of int: cost = [10, 2, 7, 8, 4, 9, 2, 9, 9];  % cost per unit of each food

% nutrient contribution per unit: [protein, carbs, calories]
array[FOODS, NUTRIENTS] of int: nutr =
  array2d(FOODS, NUTRIENTS,
    [ 7, 17,  95,   % Chicken
     12, 12, 233,   % Tofu
     14, 27, 134,   % Brown Rice
      9,  6, 109,   % Fish
     11, 19, 202,   % Lentils
     10, 23, 148,   % Quinoa
     10,  6, 184,   % Eggs
      9, 16, 136,   % Beef
      8, 25, 229    % Beans
    ]);

array[NUTRIENTS] of int: req = [71, 107, 1623];   % minimum daily requirements


% Variables
array[FOODS] of var 0..100: x;                    % number of units of each food (bounded, integer)

var int: total_cost;                              % total cost to minimize
array[NUTRIENTS] of var int: total_nutr;          % total nutrients achieved (protein, carbs, calories)


% Constraints
% Define total cost from chosen quantities
constraint total_cost = sum(f in FOODS)(cost[f] * x[f]);

% Define achieved nutrient totals from chosen quantities
constraint forall(n in NUTRIENTS) (
  total_nutr[n] = sum(f in FOODS)(nutr[f, n] * x[f])
);

% Nutritional requirement constraints: ensure minimum daily needs are met
constraint forall(n in NUTRIENTS) (
  total_nutr[n] >= req[n]
);


% Objective
solve minimize total_cost;