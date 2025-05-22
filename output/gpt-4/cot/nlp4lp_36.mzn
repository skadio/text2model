% Parameters
int: C; % Total Capacity of the Knapsack
array[1..K] of int: Value; % Value of item k
array[1..K] of int: Size; % Size of item k

% Variables
array[1..K] of var 0..1: X; % Binary variable indicating whether item k is included in the knapsack

% Constraints
constraint sum(k in 1..K)(Size[k]*X[k]) <= C; % The total size of the items in the knapsack should not exceed the capacity

% Objective
solve maximize sum(k in 1..K)(Value[k]*X[k]); % Maximize the total value of the items in the knapsack