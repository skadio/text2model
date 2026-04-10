% Optimized Diet Problem

% Parameters
int: K;                       % number of foods
int: M;                       % number of nutrients

array[1..K] of int: Price;    % price per unit of food k
array[1..M] of int: Demand;   % required amount of nutrient m
array[1..K, 1..M] of int: Nutrition; % nutrient m per unit of food k

% Variables
array[1..K] of var 0..max(Demand): Buy;

% Constraints: meet all nutrient demands
constraint
  forall(m in 1..M) (
    sum(k in 1..K) (Buy[k] * Nutrition[k, m]) >= Demand[m]
  );

% Objective: minimize total cost
solve minimize sum(k in 1..K) (Buy[k] * Price[k]);