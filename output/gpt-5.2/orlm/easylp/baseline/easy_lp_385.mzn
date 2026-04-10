% Tour planning MILP (all data embedded)

int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

int: ub1 = 20;
int: ub2 = 15;
int: ub3 = 25;
int: ub4 = 30;

var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

% Constraints
constraint x1 + x2 <= 30;
constraint 2*x3 + x4 <= 40;
constraint x1 + x2 + x3 >= 20;

% Difference constraint: x3 - 0.5*x4 <= 10  ->  2*x3 - x4 <= 20
constraint 2*x3 - x4 <= 20;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];