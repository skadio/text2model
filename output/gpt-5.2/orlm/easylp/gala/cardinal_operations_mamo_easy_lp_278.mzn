% Weekly training schedule optimization (embed all data directly)

include "globals.mzn";

% Decision variables: number of sessions for each group (whole numbers)
var 0..20: x; % Group X (strength)
var 0..20: y; % Group Y (agility)
var 0..20: z; % Group Z (strategy)

% Fatigue per session
int: fx = 4;
int: fy = 2;
int: fz = 3;

% Constraints from description
constraint x + y >= 6;
constraint abs(y - z) <= 1;
constraint x + z <= 8;

% Objective: minimize total fatigue
var int: totalFatigue = fx * x + fy * y + fz * z;

solve minimize totalFatigue;

output [
  "x (strength sessions) = ", show(x), "\n",
  "y (agility sessions)  = ", show(y), "\n",
  "z (strategy sessions) = ", show(z), "\n",
  "Minimum total fatigue (rounded) = ", show(totalFatigue), "\n"
];