% Parameters
int: C;                                    % Total capacity of the knapsack
array[int] of int: Value;                  % Value of each item
array[int] of int: Size;                   % Size  of each item

set of int: Items = index_set(Value);      % Derived index set for items (1..K)

% Variables
array[Items] of var 0..1: x;               % x[i] = 1 if item i is chosen, 0 otherwise

% Constraints
constraint
    sum(i in Items)( Size[i] * x[i] ) <= C;   % Capacity constraint

% Objective
solve maximize
    sum(i in Items)( Value[i] * x[i] );