% Parameters
int: C;                            % Total capacity of the knapsack
int: K;                            % Number of items
array[1..K] of int: Value;         % Value of item k
array[1..K] of int: Size;          % Size of item k

% Variables
array[1..K] of var 0..1: take;     % 1 if item k is taken, 0 otherwise
var int: total_value;              % Total value of chosen items
var int: total_size;               % Total size (weight) of chosen items

% Constraints
% Link total_size to chosen items
constraint
  total_size = sum(k in 1..K)(Size[k] * take[k]);

% Enforce knapsack capacity
constraint
  total_size <= C;

% Link total_value to chosen items
constraint
  total_value = sum(k in 1..K)(Value[k] * take[k]);

% Objective
solve maximize total_value;