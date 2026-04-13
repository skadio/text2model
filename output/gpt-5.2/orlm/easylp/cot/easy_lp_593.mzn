% Parameters (with values embedded)
int: n = 4;
set of int: R = 1..n;

array[R] of int: cost = [10, 20, 30, 40];

int: cap12 = 1000;
int: cap34 = 2000;

int: ub1 = 700;
int: ub2 = 800;
int: ub3 = 900;
int: ub4 = 1000;

int: diff31 = 500;
int: diff42 = 300;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(cost[1]*ub1 + cost[2]*ub2 + cost[3]*ub3 + cost[4]*ub4): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x3 >= x1 + diff31;
constraint x4 >= x2 + diff42;

constraint total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];