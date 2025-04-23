% Parameters
int: C; % Total Capacity of the Knapsack
array[int] of int: Value; % Value of each item
array[int] of int: Size; % Size of each item

% Variables
set of int: K = index_set(Value); % Set of items
array[K] of var 0..1: X; % Binary variable indicating whether item k is included in the knapsack or not

% Constraints

% The total size of the items included in the knapsack should not exceed its capacity
constraint sum(k in K)(Size[k]*X[k]) <= C;

% Each item can either be included in the knapsack or not
constraint forall(k in K)(X[k] in 0..1);

% Objective

% The objective is to maximize the total value of the items included in the knapsack
solve maximize sum(k in K)(Value[k]*X[k]);