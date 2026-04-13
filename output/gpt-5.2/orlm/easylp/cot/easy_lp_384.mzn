% Parameters (with values embedded)
int: cost1 = 20;
int: cost2 = 30;
int: cost3 = 50;
int: cost4 = 60;

int: lb1 = 0;  int: ub1 = 15;  % Strength & Conditioning
int: lb2 = 0;  int: ub2 = 12;  % Skill Development
int: lb3 = 0;  int: ub3 = 10;  % Strategy Learning
int: lb4 = 0;  int: ub4 = 8;   % Recovery Sessions

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

var 0..(ub1*cost1 + ub2*cost2 + ub3*cost3 + ub4*cost4): total_cost;

% Constraints
constraint x1 + x2 >= 5;

constraint abs(x3 - x4) <= 10;

constraint 2*x1 + 3*x2 - x4 >= 8;

constraint abs(x1 - x3) <= 6;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " (Strength & Conditioning)\n",
  "x2=", show(x2), " (Skill Development)\n",
  "x3=", show(x3), " (Strategy Learning)\n",
  "x4=", show(x4), " (Recovery Sessions)\n",
  "Minimum total cost ($)=", show(total_cost), "\n"
];