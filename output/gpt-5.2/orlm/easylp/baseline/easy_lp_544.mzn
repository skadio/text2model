% MiniZinc model: scheduling 3 tasks with integer hours
% Objective: minimize total productivity score (8,5,6 per hour)

int: p1 = 8;
int: p2 = 5;
int: p3 = 6;

var 0..30: x1;  % hours for task x1
var 0..20: x2;  % hours for task x2
var 0..15: x3;  % hours for task x3

% Constraints (scaled to avoid fractions)
% 2*x1 + 4*x2 + 3*x3 <= 40
constraint 2*x1 + 4*x2 + 3*x3 <= 40;

% x1 + 0.5*x2 - 0.25*x3 >= 10  -> multiply by 4:
constraint 4*x1 + 2*x2 - x3 >= 40;

% 2.5*x2 - (x1 + 0.75*x3) <= -20 -> multiply by 4:
constraint 10*x2 - 4*x1 - 3*x3 <= -80;

var int: obj = p1*x1 + p2*x2 + p3*x3;

solve minimize obj;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "min_total_productivity_score=", show(obj), "\n",
  "rounded_answer=", show(obj), "\n"
];