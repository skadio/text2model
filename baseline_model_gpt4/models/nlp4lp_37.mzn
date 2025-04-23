include "globals.mzn";

% Number of different types of food
int: K;
% Number of nutrients to consider
int: M;

% Price of food k
array[1..K] of int: Price;
% Demand for nutrient m
array[1..M] of int: Demand;
% Amount of nutrient m in food k
array[1..K, 1..M] of int: Nutrition;

% Decision variable: how much of each type of food to buy
array[1..K] of var 0..100: Food;

% Objective: Minimize the total cost of the food
minimize sum(i in 1..K)(Price[i]*Food[i]);

% Constraints: The total amount of each nutrient must meet the demand
constraint forall(m in 1..M)(
  sum(k in 1..K)(Nutrition[k,m]*Food[k]) >= Demand[m]
);

solve satisfy;

% Output: Amount of each type of food to buy
output ["Food " ++ show(i) ++ ": " ++ show(Food[i]) | i in 1..K];