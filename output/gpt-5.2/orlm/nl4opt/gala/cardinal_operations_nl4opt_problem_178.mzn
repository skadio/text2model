% Mall sanitizer machine purchase optimization
% Data embedded per problem statement.

% Parameters
int: drops_motion = 50;
int: kwh_motion   = 30;

int: drops_manual = 75;
int: kwh_manual   = 20;

int: min_drops = 1000;
int: max_kwh   = 500;

% Decision variables: number of machines of each type
var 0..1000: motion;
var 0..1000: manual;

% Constraints
constraint motion >= 3;

% At most 40% manual: manual <= 0.4*(manual+motion)
% Avoid fractions: 5*manual <= 2*(manual+motion)  <=> 3*manual <= 2*motion
constraint 3 * manual <= 2 * motion;

% Performance and energy constraints
constraint drops_motion * motion + drops_manual * manual >= min_drops;
constraint kwh_motion   * motion + kwh_manual   * manual <= max_kwh;

% Objective: minimize total number of machines
var 0..2000: total = motion + manual;
solve minimize total;

output [
  "motion = ", show(motion), "\n",
  "manual = ", show(manual), "\n",
  "total  = ", show(total), "\n",
  "drops_per_min = ", show(drops_motion * motion + drops_manual * manual), "\n",
  "kwh_per_min   = ", show(kwh_motion * motion + kwh_manual * manual), "\n"
];