% Parameters
int: K;
int: M;

set of int: FOODS = 1..K;
set of int: NUTRIENTS = 1..M;

array[FOODS] of int: Price;
array[NUTRIENTS] of int: Demand;
array[FOODS, NUTRIENTS] of int: Nutrition;

% Variables
array[FOODS] of var 0..max(Demand): Buy;

var int: TotalCost;

% Constraints
constraint
  forall(m in NUTRIENTS) (
    sum(k in FOODS) (Nutrition[k,m] * Buy[k]) >= Demand[m]
  );

constraint
  TotalCost = sum(k in FOODS) (Price[k] * Buy[k]);

% Objective
solve minimize TotalCost;