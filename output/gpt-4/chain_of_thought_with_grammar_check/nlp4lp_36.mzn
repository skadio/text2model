% Parameters
int: C; % Total Capacity of the Knapsack
array[int] of int: Value; % Value of item k
array[int] of int: Size; % Size of item k
set of int: K = 1..length(Value); % Set of items

% Variables
array[K] of var 0..1: x; % Binary variable indicating whether item k is included in the knapsack or not

% Constraints
constraint sum(k in K)(Size[k]*x[k]) <= C; % The total size of the items in the knapsack should not exceed its capacity

% Objective
var int: total_value = sum(k in K)(Value[k]*x[k]); % Total value of the items in the knapsack
solve maximize total_value; % We want to maximize the total value of the items in the knapsack