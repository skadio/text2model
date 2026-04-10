% Parameters (with values embedded)
int: c1 = 50;
int: c2 = 75;
int: c3 = 100;
int: c4 = 125;

int: cap12 = 5000;
int: cap34 = 3000;

int: min13 = 2000;
int: min24 = 4000;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];