int: K;                          % Number of different types of food
int: M;                          % Number of nutrients to consider
array[1..K] of int: Price;      % Price of food k
array[1..M] of int: Demand;     % Demand for nutrient m
array[1..K, 1..M] of int: Nutrition; % Amount of nutrient m in food k

array[1..K] of var 0..max(Demand) : x; % Amount of each food type to buy

% Constraints to meet the nutritional demands
constraint forall(m in 1..M)(
    sum(k in 1..K)(Nutrition[k, m] * x[k]) >= Demand[m]
);

% Objective: Minimize the total cost
var int: total_cost = sum(k in 1..K)(Price[k] * x[k]);
solve minimize total_cost;

% Output the results
output [ "Total Cost = ", show(total_cost), "\n", 
         "Food Amounts = ", show(x), "\n" ];