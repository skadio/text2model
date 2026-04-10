include "globals.mzn";

% Data (embedded as requested)
int: maxHours = 15;                 % maximum allowed time per week (as stated)
array[1..4] of int: fatigue = [5,4,3,6];  % X1..X4 per-hour fatigue scores

% Decision variables: whole numbers of hours for each training group
% X1=strength, X2=skill, X3=strategy, X4=recovery
array[1..4] of var 0..maxHours: X;

% Constraints
constraint X[1] + X[2] <= 15;                 % X1 + X2 <= 15
constraint X[2] + X[3] >= 10;                 % X2 + X3 >= 10
constraint abs(X[3] - X[4]) <= 8;             % |X3 - X4| <= 8
constraint X[1] >= 2 * X[4] + 5;              % X1 at least five more than twice X4

% Objective: minimize total fatigue score
var int: totalFatigue = sum(i in 1..4)(fatigue[i] * X[i]);

solve minimize totalFatigue;

output [
  "X1(strength) = ", show(X[1]), "\n",
  "X2(skill)    = ", show(X[2]), "\n",
  "X3(strategy) = ", show(X[3]), "\n",
  "X4(recovery) = ", show(X[4]), "\n",
  "Minimum total fatigue (rounded) = ", show(totalFatigue), "\n"
];