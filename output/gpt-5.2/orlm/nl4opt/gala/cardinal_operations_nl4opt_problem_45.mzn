% Oil production profit maximization (integer linear programming)
include "globals.mzn";

% ----- Data (embedded from the description) -----
int: nProducts = 2;
set of int: P = 1..nProducts;

% Product names for output
array[P] of string: pname = ["Oil Max", "Oil Max Pro"];

% Available amounts of substances
int: availA = 1345;
int: availB = 346;
int: availC = 1643;

% Consumption per container for each product (A, B, C)
array[P] of int: useA = [46, 13];
array[P] of int: useB = [43,  4];
array[P] of int: useC = [56, 45];

% Profit per container
array[P] of int: profit = [10, 15];

% ----- Decision variables -----
% x[p] = number of containers produced of product p
array[P] of var 0..max(availA, max(availB, availC)): x;

% ----- Constraints (resource limits) -----
constraint sum(p in P)(useA[p] * x[p]) <= availA;
constraint sum(p in P)(useB[p] * x[p]) <= availB;
constraint sum(p in P)(useC[p] * x[p]) <= availC;

% ----- Objective -----
var int: total_profit = sum(p in P)(profit[p] * x[p]);
solve maximize total_profit;

% ----- Output -----
output [
  "Production plan:\n",
  concat([ pname[p] ++ " = " ++ show(x[p]) ++ "\n" | p in P ]),
  "Total profit = $", show(total_profit), "\n",
  "Used A = ", show(sum(p in P)(useA[p]*x[p])), " / ", show(availA), "\n",
  "Used B = ", show(sum(p in P)(useB[p]*x[p])), " / ", show(availB), "\n",
  "Used C = ", show(sum(p in P)(useC[p]*x[p])), " / ", show(availC), "\n"
];