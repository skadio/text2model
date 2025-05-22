% Parameters
int: K; % Number of different types of food
int: M; % Number of nutrients to consider
array[1..K] of int: Price; % Price of food k
array[1..M] of int: Demand; % Demand for nutrient m
array[1..K, 1..M] of int: Nutrition; % Amount of nutrient m in food k

% Variables
array[1..K] of var 0..100: Food; % Amount of each type of food to buy

% Constraints
constraint forall(m in 1..M)(
  sum(k in 1..K)(Nutrition[k,m]*Food[k]) >= Demand[m]
);

% Objective
var int: TotalCost = sum(k in 1..K)(Price[k]*Food[k]);
solve minimize TotalCost;