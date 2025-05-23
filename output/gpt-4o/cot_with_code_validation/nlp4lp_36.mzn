% Parameters
int: C;                                   % Total capacity of the knapsack

array[int] of int: Value;                 % Value of each item
set of int: ITEMS = index_set(Value);     % Derived index set of items
array[ITEMS] of int: Size;                % Size of each item

% Decision variables
array[ITEMS] of var 0..1: x;              % x[i] = 1 if item i is selected

% Capacity constraint
constraint
    sum(i in ITEMS)(Size[i] * x[i]) <= C;

% Objective
solve maximize sum(i in ITEMS)(Value[i] * x[i]);