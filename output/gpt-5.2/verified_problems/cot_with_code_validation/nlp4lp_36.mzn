% Knapsack problem (0/1)

% Parameters (from .dzn)
int: C;                         % capacity
array[int] of int: Value;       % item values
array[int] of int: Size;        % item sizes

% Derived parameter
int: K = length(Value);

% Decision variables
array[1..K] of var bool: x;

% Constraints
constraint length(Size) = K;
constraint forall(i in 1..K)(Value[i] >= 0 /\ Size[i] >= 0);

constraint sum(i in 1..K)(Size[i] * bool2int(x[i])) <= C;

% Objective
var int: total_value = sum(i in 1..K)(Value[i] * bool2int(x[i]));
solve maximize total_value;

output [
  "total_value=", show(total_value), "\n",
  "x=", show([bool2int(x[i]) | i in 1..K]), "\n"
];