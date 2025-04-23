% Parameters
int: K; % Number of different types of food
int: M; % Number of nutrients to consider
array[1..K] of float: Price; % Price of each type of food
array[1..M] of float: Demand; % Demand for each nutrient
array[1..K, 1..M] of float: Nutrition; % Amount of each nutrient in each type of food

% Variables
array[1..K] of var float+: Food; % Amount of each type of food to buy

% Constraints

% Ensure that the total amount of each nutrient in the food we buy meets our demand
constraint forall(m in 1..M) (
    sum(k in 1..K) (Food[k] * Nutrition[k, m]) >= Demand[m]
);

% Ensure that we do not buy negative amounts of food
constraint forall(k in 1..K) (
    Food[k] >= 0
);

% Objective

% Minimize the total cost of the food we buy
solve minimize sum(k in 1..K) (Food[k] * Price[k]);