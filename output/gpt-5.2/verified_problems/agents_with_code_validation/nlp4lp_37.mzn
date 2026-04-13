% Parameters
int: K;                                % number of food types
int: M;                                % number of nutrients

array[1..K] of int: Price;             % price per unit of each food k
array[1..M] of int: Demand;            % required amount of each nutrient m
array[1..K, 1..M] of int: Nutrition;   % nutrient m provided by one unit of food k

% Variables
array[1..K] of var int: Buy;           % units of each food k to buy (non-negative integer)

% Constraints
% --- Domain: non-negative purchase quantities ---
constraint
  forall(k in 1..K) (
    Buy[k] >= 0
  );

% --- Nutrient requirements: meet or exceed demand for each nutrient ---
% For each nutrient m, sum over foods k of (units bought * nutrient content) >= demand
constraint
  forall(m in 1..M) (
    sum(k in 1..K) (Buy[k] * Nutrition[k, m]) >= Demand[m]
  );

% Objective
solve minimize sum(k in 1..K) (Buy[k] * Price[k]);