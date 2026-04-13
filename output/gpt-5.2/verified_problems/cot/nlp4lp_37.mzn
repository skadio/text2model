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

var 0..sum(f in FOODS)(Price[f] * max(Demand)): TotalCost;

% Constraints
constraint
  forall(m in NUTRIENTS)(
    sum(f in FOODS)(Nutrition[f, m] * Buy[f]) >= Demand[m]
  );

constraint
  TotalCost = sum(f in FOODS)(Price[f] * Buy[f]);

% Objective
solve minimize TotalCost;