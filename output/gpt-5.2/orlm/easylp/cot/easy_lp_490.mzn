% Parameters (with values embedded)
int: a1 = 10;        % coefficient of X in logistical constraint
int: b1 = 20;        % coefficient of Y in logistical constraint
int: c1 = 3000;      % upper bound for logistical constraint

int: a2 = 3;         % coefficient of X in strength constraint
int: b2 = 5;         % coefficient of Y in strength constraint
int: c2 = 500;       % lower bound for strength constraint

int: maxDiff = 1000; % maximum allowed absolute difference

int: costX = 10000;  % dollars per unit X
int: costY = 20000;  % dollars per unit Y

% Variable bounds (safe implied bounds from constraints)
int: maxX = c1 div a1;  % 3000/10 = 300
int: maxY = c1 div b1;  % 3000/20 = 150

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint a1*X + b1*Y <= c1;
constraint a2*X + b2*Y >= c2;
constraint abs(X - Y) <= maxDiff;

constraint totalCost = costX*X + costY*Y;

% Objective
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];