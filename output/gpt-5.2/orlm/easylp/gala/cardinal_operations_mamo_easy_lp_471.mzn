include "globals.mzn";

% Data (embedded from problem description)
int: fatigueX = 10;
int: fatigueY = 20;

int: maxWeightedHours = 60;   % 3*X + 2*Y <= 60
int: minTotalHours = 12;      % X + Y >= 12
int: maxDiff = 8;             % |Y - X| <= 8

% Decision variables (whole weekly training hours)
var 0..60: X;   % strength conditioning hours (group X)
var 0..60: Y;   % skill development hours (group Y)

% Constraints
constraint 3*X + 2*Y <= maxWeightedHours;
constraint X + Y >= minTotalHours;
constraint abs(Y - X) <= maxDiff;

% Objective: minimize total fatigue score
var int: totalFatigue = fatigueX * X + fatigueY * Y;
solve minimize totalFatigue;

output [
  "X (strength hours) = ", show(X), "\n",
  "Y (skill hours)    = ", show(Y), "\n",
  "Total fatigue      = ", show(totalFatigue), "\n"
];