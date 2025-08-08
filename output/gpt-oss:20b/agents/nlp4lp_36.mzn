include "globals.mzn";

int: C;                       % capacity
array[1..] of int: Value;     % values of the items
array[1..] of int: Size;      % sizes of the items

int: K = length(Value);       % number of items

array[1..K] of var 0..1: x;   % 1 = item selected, 0 = not

% Capacity constraint
constraint sum(i in 1..K)(x[i] * Size[i]) <= C;

% Objective: maximise total value
solve maximize sum(i in 1..K)(x[i] * Value[i]);

output [
  "Selected items: ", show([i | i in 1..K where x[i] = 1]), "\n",
  "Total value   : ", show(sum(i in 1..K)(x[i] * Value[i])), "\n",
  "Total weight  : ", show(sum(i in 1..K)(x[i] * Size[i])), "\n"
];