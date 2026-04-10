% Parameters (with values embedded)
int: raw_len = 10;                 % length of each raw bar (m)
int: demand3 = 90;                 % required number of 3m pieces
int: demand4 = 60;                 % required number of 4m pieces

% Enumerate all feasible cutting patterns (a,b) where a*3 + b*4 <= 10
int: P = 6;
array[1..P] of int: a3 = [0, 0, 0, 1, 2, 3];   % number of 3m pieces in pattern p
array[1..P] of int: a4 = [0, 1, 2, 1, 1, 0];   % number of 4m pieces in pattern p
array[1..P] of int: waste = [10, 6, 2, 3, 0, 1]; % waste (m) in pattern p

% Variables
% x[p] = number of 10m raw bars cut using pattern p
array[1..P] of var 0..200: x;

% Constraints
constraint sum(p in 1..P)(a3[p] * x[p]) = demand3;
constraint sum(p in 1..P)(a4[p] * x[p]) = demand4;

% Objective
var 0..2000: total_waste = sum(p in 1..P)(waste[p] * x[p]);
solve minimize total_waste;

output [
  "Total waste (m): ", show(total_waste), "\n",
  "Patterns (3m,4m,waste) with counts:\n"
] ++
[
  "(" ++ show(a3[p]) ++ "," ++ show(a4[p]) ++ "," ++ show(waste[p]) ++ "): " ++ show(x[p]) ++ "\n"
  | p in 1..P
];