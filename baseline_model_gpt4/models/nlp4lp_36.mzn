% Define the parameters
int: C; % Total capacity of the knapsack
set of int: K = 1..length(Value); % Set of items
array[K] of int: Value; % Value of each item
array[K] of int: Size; % Size of each item

% Define the decision variables
array[K] of var 0..1: x; % Binary variable indicating whether each item is included in the knapsack

% Define the objective function
var int: total_value = sum(k in K)(Value[k]*x[k]);
maximize total_value;

% Define the constraints
constraint sum(k in K)(Size[k]*x[k]) <= C;

% Output the solution
output [ "Total value: ", show(total_value), "\n",
          "Items included: ", show([k | k in K where x[k] = 1]), "\n"];