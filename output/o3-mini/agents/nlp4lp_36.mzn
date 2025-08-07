int: C;                     % Total capacity of the knapsack
int: K;                     % Number of items
array[1..K] of int: Value;  % Value of each item
array[1..K] of int: Size;   % Size of each item

% Decision variable: x[i] = 1 if item i is chosen, 0 otherwise
array[1..K] of var 0..1: x;

% Capacity constraint: total size of chosen items must not exceed C
constraint sum(i in 1..K)(Size[i]*x[i]) <= C;

% Objective: maximize the total value of chosen items
solve maximize sum(i in 1..K)(Value[i]*x[i]);

output [
  "Selected Items: ", show(x), "\n",
  "Total Value: ", show(sum(i in 1..K)(Value[i]*x[i])), "\n",
  "Total Size: ", show(sum(i in 1..K)(Size[i]*x[i])), "\n"
];