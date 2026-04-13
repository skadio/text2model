% HR allocation / staffing cost minimization
include "globals.mzn";

% Embedded data (as required)
int: maxTotal = 10;

int: minX1 = 2;
int: minX2 = 3;
int: minX3 = 5;

int: lbX1 = 0; int: ubX1 = 6;
int: lbX2 = 0; int: ubX2 = 4;
int: lbX3 = 0; int: ubX3 = 5;

int: costX1 = 50000;
int: costX2 = 60000;
int: costX3 = 70000;

% Decision variables: number of employees in each department
var lbX1..ubX1: x1;
var lbX2..ubX2: x2;
var lbX3..ubX3: x3;

% Constraints
constraint x1 + x2 + x3 <= maxTotal;
constraint x1 >= minX1;
constraint x2 >= minX2;
constraint x3 >= minX3;

% Objective: minimize total cost
var int: totalCost = costX1*x1 + costX2*x2 + costX3*x3;

solve minimize totalCost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "totalCost=", show(totalCost), "\n"
];