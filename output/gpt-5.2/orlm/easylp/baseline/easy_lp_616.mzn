% Resource allocation / cost minimization for 4 projects

int: c1 = 100;
int: c2 = 200;
int: c3 = 150;
int: c4 = 50;

int: ub1 = 500;
int: ub2 = 300;
int: ub3 = 200;
int: ub4 = 400;

var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x1 + x3 >= 800;
constraint 2*x4 >= x1;                       % x4 >= 0.5*x1
constraint abs(x3 - 4*x2) <= 2000;           % |(x3/4) - x2| <= 500  => |x3 - 4x2| <= 2000
constraint x2 + x4 - x1 - x3 = 70;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];