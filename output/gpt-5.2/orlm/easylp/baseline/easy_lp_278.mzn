% Weekly training schedule optimization (embedded data)

% Decision variables: number of sessions for each group (integers)
var 0..10: X; % strength training sessions
var 0..10: Y; % agility drills sessions
var 0..10: Z; % strategic planning sessions

% Bounds on session allocation due to available resources (assumed finite bounds)
constraint X >= 0 /\ X <= 10;
constraint Y >= 0 /\ Y <= 10;
constraint Z >= 0 /\ Z <= 10;

% Constraints from problem statement
constraint X + Y >= 6;
constraint abs(Y - Z) <= 1;
constraint X + Z <= 8;

% Fatigue scores per session
int: fx = 4;
int: fy = 2;
int: fz = 3;

% Objective: minimize total fatigue
var int: total_fatigue = fx*X + fy*Y + fz*Z;
solve minimize total_fatigue;

% Output (minimum is already an integer, so rounding is implicit)
output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_fatigue=", show(total_fatigue), "\n"
];