% Parameters
int: K; % number of food types
int: M; % number of nutrients
array[1..K] of int: Price; % price per unit of each food
array[1..M] of int: Demand; % required amount of each nutrient
array[1..K, 1..M] of int: Nutrition; % nutrient content of each food

% Variables
var float: quantity[1..K] >= 0; % amount of each food to purchase

% Constraints
constraint
  forall(m in 1..M) (
    sum(k in 1..K) (quantity[k] * Nutrition[k, m]) >= Demand[m]
  );

% Objective
solve minimize
  sum(k in 1..K) (quantity[k] * Price[k]);