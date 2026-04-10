include "globals.mzn";

% Data (embedded as requested)
int: costX = 7;
int: costY = 9;

int: a1 = 4;  int: b1 = 5;  int: rhs1 = 1000;   % 4*X + 5*Y <= 1000
int: a2 = 3;  int: b2 = 2;  int: rhs2 = 200;    % 3*X - 2*Y >= 200
int: rhs3 = 300;                                % X + Y <= 300

% Decision variables (integer investments)
var 0..100000: X;
var 0..100000: Y;

% Constraints
constraint a1*X + b1*Y <= rhs1;
constraint a2*X - b2*Y >= rhs2;
constraint X + Y <= rhs3;

% Objective: minimize total cost score
var int: totalCost = costX*X + costY*Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost score = ", show(totalCost), "\n"
];