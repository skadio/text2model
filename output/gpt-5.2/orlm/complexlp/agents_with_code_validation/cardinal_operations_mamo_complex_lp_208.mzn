% Parameters
int: nFoods = 4;                     % number of available foods
set of int: FOODS = 1..nFoods;       % index set for foods

% Food indices (for readability)
int: BROWNIE = 1;
int: ICECREAM = 2;
int: COLA = 3;
int: CHEESECAKE = 4;

% Cost per unit (cents)
array[FOODS] of int: cost = [50, 20, 30, 80];

% Nutritional content per unit
array[FOODS] of int: calories  = [400, 200, 150, 500];
array[FOODS] of int: chocolate = [  3,   2,   0,   0];   % oz
array[FOODS] of int: sugar     = [  2,   2,   4,   4];   % oz
array[FOODS] of int: fat       = [  2,   4,   1,   5];   % oz

% Daily minimum requirements
int: minCalories  = 500;
int: minChocolate = 6;   % oz
int: minSugar     = 10;  % oz
int: minFat       = 8;   % oz


% Variables
array[FOODS] of var int: qty;         % quantity of each food consumed (units, integer)

var int: totalCost;                   % total cost (cents)
var int: totalCalories;               % total calories
var int: totalChocolate;              % total chocolate (oz)
var int: totalSugar;                  % total sugar (oz)
var int: totalFat;                    % total fat (oz)


% Constraints
% Non-negativity of quantities (feasible consumption amounts)
constraint
  forall(f in FOODS) (
    qty[f] >= 0
  );

% Totals (link decision variables to aggregate nutritional intake and cost)
constraint
  totalCost = sum(f in FOODS) (cost[f] * qty[f]);

constraint
  totalCalories = sum(f in FOODS) (calories[f] * qty[f]);

constraint
  totalChocolate = sum(f in FOODS) (chocolate[f] * qty[f]);

constraint
  totalSugar = sum(f in FOODS) (sugar[f] * qty[f]);

constraint
  totalFat = sum(f in FOODS) (fat[f] * qty[f]);

% Minimum daily nutritional requirements
constraint totalCalories  >= minCalories;
constraint totalChocolate >= minChocolate;
constraint totalSugar     >= minSugar;
constraint totalFat       >= minFat;


% Objective
solve minimize totalCost;