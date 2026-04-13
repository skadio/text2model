% 0/1 Knapsack (maximize total value under capacity)
% Data provided in .dzn:
%   int: C;
%   array[1..K] of int: Value;
%   array[1..K] of int: Size;

include "globals.mzn";

array[int] of int: Value;
array[int] of int: Size;
int: C;

int: K = length(Value);
set of int: ITEMS = 1..K;

constraint length(Size) = K;
constraint C >= 0;
constraint forall(i in ITEMS)(Value[i] >= 0 /\ Size[i] >= 0);

array[ITEMS] of var 0..1: take;

var int: total_size = sum(i in ITEMS)(Size[i] * take[i]);
var int: total_value = sum(i in ITEMS)(Value[i] * take[i]);

constraint total_size <= C;

solve maximize total_value;

output [
  "take = ", show(take), "\n",
  "total_size = ", show(total_size), " / C = ", show(C), "\n",
  "total_value = ", show(total_value), "\n"
];