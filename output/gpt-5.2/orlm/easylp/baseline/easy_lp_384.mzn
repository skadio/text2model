% Training hours allocation - cost minimization (all data embedded)

int: c1 = 20;
int: c2 = 30;
int: c3 = 50;
int: c4 = 60;

var 0..15: x1; % Strength & Conditioning
var 0..12: x2; % Skill Development
var 0..10: x3; % Strategy Learning
var 0..8:  x4; % Recovery Sessions

constraint x1 + x2 >= 5;

% Difference between strategy learning and recovery cannot exceed 10
constraint abs(x3 - x4) <= 10;

% Twice strength + three times skill - recovery >= 8
constraint 2*x1 + 3*x2 - x4 >= 8;

% Difference between strength and strategy cannot exceed 6
constraint abs(x1 - x3) <= 6;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];