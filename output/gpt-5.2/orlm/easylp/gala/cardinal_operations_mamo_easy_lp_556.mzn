include "globals.mzn";

% Decision variables (whole-number effort units)
var int: x1; % strength conditioning
var int: x2; % skill development
var int: x3; % strategy and tactics

% Domain bounds (safe, derived from constraints; keeps the model finite)
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0;
constraint x1 <= 10 /\ x2 <= 10;        % from x1 + x2 <= 10
constraint x3 <= 20;                    % from 5*x3 <= 4*x1+5*x3, with x1<=10 -> 4*x1+5*x3>=20 implies x3 needn't exceed 20

% Constraints
constraint x1 + x2 <= 10;
constraint 4 * x1 + 5 * x3 >= 20;
constraint abs(x3 - x2) <= 5;
constraint 2 * x3 >= x1;  % x3 >= x1/2

% Objective: minimize total fatigue score
var int: fatigue = 2 * x1 + 3 * x2 + 5 * x3;

solve minimize fatigue;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_fatigue_score = ", show(fatigue), "\n"
];