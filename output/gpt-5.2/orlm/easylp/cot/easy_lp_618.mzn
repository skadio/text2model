% Parameters (with values embedded)
int: nTeams = 4;
set of int: TEAMS = 1..nTeams;

% Fatigue per hour for teams X1..X4
array[TEAMS] of int: fatigue = [2, 3, 4, 5];

% Variable bounds (hours) - nonnegative integers (no explicit upper bounds given)
int: U = 100; % sufficiently large upper bound for feasibility
% Variables
array[TEAMS] of var 0..U: x; % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4

% Constraints
constraint x[1] + x[2] <= 8;
constraint 2*x[2] + x[3] >= 10;
constraint x[3] - 3*x[4] <= 15;
constraint x[4] - x[1] = 5;

% Objective
var int: total_fatigue = sum(t in TEAMS)(fatigue[t] * x[t]);
solve minimize total_fatigue;

output [
  "X1=", show(x[1]), " X2=", show(x[2]), " X3=", show(x[3]), " X4=", show(x[4]), "\n",
  "Minimum total fatigue (rounded) = ", show(total_fatigue), "\n"
];