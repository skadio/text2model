% Manufacturing cost minimization (integer linear program)

include "globals.mzn";

% --- Data (embedded, as requested) ---
int: A_avail = 1000;
int: B_avail = 800;

int: demand_rhs = 100; % x1 - 2*x2 + x3 >= 100

int: x1_max = 300;
int: x2_max = 200;
int: x3_max = 150;

int: c1 = 10;
int: c2 = 15;
int: c3 = 20;

% Resource consumption per unit
int: A1 = 5; int: B1 = 4;
int: A2 = 3; int: B2 = 6;
int: A3 = 8; int: B3 = 7;

% --- Decision variables ---
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;

% --- Constraints ---
constraint A1*x1 + A2*x2 + A3*x3 <= A_avail;
constraint B1*x1 + B2*x2 + B3*x3 <= B_avail;

constraint x1 - 2*x2 + x3 >= demand_rhs;

% --- Objective ---
var int: total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];