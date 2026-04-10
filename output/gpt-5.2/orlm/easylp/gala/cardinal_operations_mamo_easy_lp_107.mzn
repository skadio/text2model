include "globals.mzn";

% Data (embedded from the problem statement)
int: max_total_hours = 50;
int: min_effectiveness = 20;      % 2*X + Y >= 20
int: diff_limit = 10;             % |X - 3*Y| <= 10
int: cost_x = 5;                  % fatigue per hour of X
int: cost_y = 3;                  % fatigue per hour of Y

% Decision variables (whole hours)
var 0..max_total_hours: x;        % hours of workout X
var 0..max_total_hours: y;        % hours of workout Y

% Constraints
constraint x + y <= max_total_hours;
constraint 2*x + y >= min_effectiveness;
constraint abs(x - 3*y) <= diff_limit;

% Objective: minimize total fatigue
var 0..(cost_x*max_total_hours + cost_y*max_total_hours): fatigue;
constraint fatigue = cost_x*x + cost_y*y;

solve minimize fatigue;

output [
  "x (hours) = ", show(x), "\n",
  "y (hours) = ", show(y), "\n",
  "minimum fatigue = ", show(fatigue), "\n"
];