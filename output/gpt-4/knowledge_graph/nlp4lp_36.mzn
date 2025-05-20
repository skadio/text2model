% Parameters
int: C; % Total capacity of the knapsack
set of int: K = 1..length(Value); % Set of items
array[K] of int: Value; % Value of each item
array[K] of int: Size; % Size of each item

% Decision Variables
array[K] of var 0..1: X; % Binary variable indicating whether an item is included in the knapsack or not

% Constraints
constraint sum(i in K)(Size[i]*X[i]) <= C; % The total size of the items in the knapsack should not exceed its capacity

% Objective
var int: TotalValue = sum(i in K)(Value[i]*X[i]); % Total value of the items in the knapsack
solve maximize TotalValue; % Maximize the total value

% Output
output ["Total Value: ", show(TotalValue), "\n"] ++ ["Item ", show(i), " included: ", show(X[i]), "\n" | i in K];