% Steel bar cutting (1D cutting stock) as an ILP in MiniZinc
% Raw bar length: 10m
% Demand: 90 pieces of 3m, 60 pieces of 4m
% Objective: minimize total waste (trim loss)

int: L = 10;
array[1..2] of int: itemLen = [3, 4];
array[1..2] of int: demand  = [90, 60];

% Enumerate all feasible cutting patterns for a 10m bar
% Pattern i: (a,b) where a=#3m pieces, b=#4m pieces, and 3a+4b<=10
int: P = 5;
array[1..P] of int: p3 = [0, 0, 0, 1, 2];
array[1..P] of int: p4 = [0, 1, 2, 1, 1];

array[1..P] of int: waste = [
  L - (3*p3[1] + 4*p4[1]),  % 10
  L - (3*p3[2] + 4*p4[2]),  % 6
  L - (3*p3[3] + 4*p4[3]),  % 2
  L - (3*p3[4] + 4*p4[4]),  % 3
  L - (3*p3[5] + 4*p4[5])   % 0
];

% Decision variables: how many raw 10m bars cut with each pattern
array[1..P] of var 0..200: x;

constraint sum(i in 1..P)(p3[i] * x[i]) >= demand[1]; % satisfy 3m demand
constraint sum(i in 1..P)(p4[i] * x[i]) >= demand[2]; % satisfy 4m demand

var int: totalWaste = sum(i in 1..P)(waste[i] * x[i]);
solve minimize totalWaste;

output [
  "Total waste (m): ", show(totalWaste), "\n",
  "Patterns (p3,p4,waste) and usage:\n",
  concat([ "  (" ++ show(p3[i]) ++ "," ++ show(p4[i]) ++ "," ++ show(waste[i]) ++ ") : "
           ++ show(x[i]) ++ "\n"
         | i in 1..P ])
];