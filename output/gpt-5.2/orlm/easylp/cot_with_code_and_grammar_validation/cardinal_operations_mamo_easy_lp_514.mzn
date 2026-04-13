% Parameters (embedded data)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;

int: cap1 = 1000;   % x1 + 2*x2 <= 1000
int: rhs2 = 300;    % 3*x1 >= x3 + 300
int: cap3 = 1500;   % 4*x2 + x3 <= 1500
int: cap4 = 70;     % 5*x2 - (x1 + x3) <= 70

% Bounds (not specified in the prompt; assume non-negative and keep safe upper bounds)
int: lb1 = 0;  int: ub1 = 100000;
int: lb2 = 0;  int: ub2 = 100000;
int: lb3 = 0;  int: ub3 = 100000;

% Decision variables (integers)
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;

% Total cost (bounded to avoid undefined intmax)
var 0..(c1*ub1 + c2*ub2 + c3*ub3): total_cost;

% Constraints
constraint x1 + 2 * x2 <= cap1;
constraint 3 * x1 >= x3 + rhs2;
constraint 4 * x2 + x3 <= cap3;
constraint 5 * x2 - (x1 + x3) <= cap4;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];