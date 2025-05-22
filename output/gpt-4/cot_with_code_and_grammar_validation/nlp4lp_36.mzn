% Parameters
int: C; % Total Capacity of the Knapsack
array[1..2] of int: Value; % Value of item k
array[1..2] of int: Size; % Size of item k
set of int: K = 1..2; % Set of items

% Variables
array[K] of var 0..1: x; % Binary variable indicating whether item k is included in the knapsack

% Constraints
constraint sum(k in K)(Size[k]*x[k]) <= C; % The total size of the items in the knapsack should not exceed its capacity

% Objective
var int: total_value = sum(k in K)(Value[k]*x[k]); % Total value of the items in the knapsack
solve maximize total_value; % Maximize the total value of the items in the knapsack