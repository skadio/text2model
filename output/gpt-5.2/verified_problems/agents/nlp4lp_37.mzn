% Parameters
int: K;                              % Number of different types of food
int: M;                              % Number of nutrients to consider

array[1..K] of int: Price;           % Price per unit of food k
array[1..M] of int: Demand;          % Required demand for nutrient m
array[1..K, 1..M] of int: Nutrition; % Amount of nutrient m in one unit of food k

% Variables
array[1..K] of var int: Buy;         % Units of each food k to buy (non-negative)
var int: TotalCost;                  % Total cost of the diet plan

% Constraints
% Non-negativity for purchase decisions
constraint forall(k in 1..K) (Buy[k] >= 0);

% Define total cost
constraint TotalCost = sum(k in 1..K)(Price[k] * Buy[k]);

% Nutrient demand satisfaction:
% For each nutrient m, total obtained from all purchased foods >= required demand
constraint
  forall(m in 1..M) (
    sum(k in 1..K) (Nutrition[k, m] * Buy[k]) >= Demand[m]
  );

% Objective
solve minimize TotalCost;