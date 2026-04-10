% Parameters
int: K;
int: M;

array[1..K] of int: Price;
array[1..M] of int: Demand;
array[1..K, 1..M] of int: Nutrition;

% Variables
array[1..K] of var 0..sum(Demand): Buy;

var 0..(sum(Price) * sum(Demand)): TotalCost;

% Constraints
constraint
  forall(k in 1..K) (Buy[k] >= 0);

constraint
  forall(m in 1..M) (
    sum(k in 1..K) (Nutrition[k,m] * Buy[k]) >= Demand[m]
  );

constraint
  TotalCost = sum(k in 1..K) (Price[k] * Buy[k]);

% Objective
solve minimize TotalCost;