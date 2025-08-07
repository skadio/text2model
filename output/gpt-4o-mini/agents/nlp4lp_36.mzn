int: C;                          % Total Capacity of the Knapsack
array[int] of int: Value;       % Value of each item
array[int] of int: Size;        % Size of each item
int: K = length(Value);         % Number of items

% Decision variables: whether to include item k in the knapsack
array[1..K] of var 0..1: x;     % x[k] = 1 if item k is included, 0 otherwise

% Constraints
constraint sum(k in 1..K)(Size[k] * x[k]) <= C;  % Total size must not exceed capacity

% Objective: maximize the total value of the selected items
var int: totalValue = sum(k in 1..K)(Value[k] * x[k]);
solve maximize totalValue;

% Output
output [ "Total Value = ", show(totalValue), "\nItems included = ", show(x), "\n" ];