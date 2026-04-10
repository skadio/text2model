include "globals.mzn";

/* Data (embedded from problem statement) */
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;
int: c4 = 40;

int: ub1 = 700;
int: ub2 = 800;
int: ub3 = 900;
int: ub4 = 1000;

int: cap12 = 1000;
int: cap34 = 2000;

int: diff31 = 500;  % x3 >= x1 + 500
int: diff42 = 300;  % x4 >= x2 + 300

/* Decision variables: integer resource allocations */
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

/* Constraints */
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x3 >= x1 + diff31;
constraint x4 >= x2 + diff42;

/* Objective */
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

/* Output */
output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum total cost (rounded) = ", show(total_cost), "\n"
];