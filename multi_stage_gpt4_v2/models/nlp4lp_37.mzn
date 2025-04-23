% Parameters
int: K; % Number of different types of food
int: M; % Number of nutrients to consider
array[1..K] of float: Price; % Price of food k
array[1..M] of float: Demand; % Demand for nutrient m
array[1..K, 1..M] of float: Nutrition; % Amount of nutrient m in food k

% Variables
array[1..K] of var 0..1000000: Food; % Amount of each type of food to buy

% Constraints

% Ensure that the total amount of each nutrient from all foods meets the demand
constraint forall(m in 1..M)(
  sum(k in 1..K)(Nutrition[k, m] * Food[k]) >= Demand[m]
);

% Ensure that the amount of each food to buy is non-negative
constraint forall(k in 1..K)(
  Food[k] >= 0
);

% Objective

% Minimize the total cost of the food
solve minimize sum(k in 1..K)(Price[k] * Food[k]);