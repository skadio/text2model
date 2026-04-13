include "globals.mzn";

% Data (embedded from the problem statement)
array[1..4] of int: avail = [700, 500, 600, 800];   % available vehicles of types x1..x4
array[1..4] of int: cost  = [50, 60, 70, 80];       % daily operating cost per vehicle

int: op1_cap = 1000;   % x1 + x2 up to 1000 (operation 1)
int: op2_cap = 1200;   % x3 + x4 up to 1200 (operation 2)

int: min_heavy = 800;  % at least 800 from x1 or x3
int: min_req   = 600;  % at least 600 from x2 or x4

% Decision variables: number of vehicles allocated of each type (integers)
array[1..4] of var 0..max(avail): x;

% Availability constraints
constraint forall(i in 1..4)(x[i] <= avail[i]);

% Operation capacity constraints
constraint x[1] + x[2] <= op1_cap;
constraint x[3] + x[4] <= op2_cap;

% Composition constraints
constraint x[1] + x[3] >= min_heavy;
constraint x[2] + x[4] >= min_req;

% Objective: minimize total daily operating cost
var int: total_cost = sum(i in 1..4)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "minimum_daily_operating_cost = ", show(total_cost), "\n"
];