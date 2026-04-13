int: c1 = 2;
int: c2 = 3;
int: c3 = 4;

% Production bounds (not specified in the description; using nonnegativity)
int: lb1 = 0; int: ub1 = 1000000;
int: lb2 = 0; int: ub2 = 1000000;
int: lb3 = 0; int: ub3 = 1000000;

var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;

% Constraints
constraint x1 + 2*x2 <= 1000;
constraint 3*x1 >= x3 + 300;
constraint 4*x2 + x3 <= 1500;
constraint 5*x2 - (x1 + x3) <= 70;

var int: total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];