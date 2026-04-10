% Training hours allocation (integer hours)
% Groups: x1 skill, x2 strength, x3 strategy, x4 recovery

int: c1 = 10;
int: c2 = 15;
int: c3 = 12;
int: c4 = 20;

% Bounds (not provided explicitly; use nonnegative integer hours)
int: LB = 0;
int: UB = 100;

var LB..UB: x1;
var LB..UB: x2;
var LB..UB: x3;
var LB..UB: x4;

% Constraints
constraint x1 + x2 <= 8;
constraint x3 + x4 <= 10;
constraint x1 + x3 >= 5;
constraint x2 + x4 >= 6;

% Objective: minimize total fatigue score
var int: fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "fatigue=", show(fatigue), "\n",
  "rounded_fatigue=", show(fatigue), "\n"
];