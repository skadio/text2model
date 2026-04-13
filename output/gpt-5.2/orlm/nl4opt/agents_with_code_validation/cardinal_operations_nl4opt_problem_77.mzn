% Medicine delivery and waste minimization (LP)
% Use floats, but avoid unbounded float variables (can break some solvers like Gecode).

% Parameters (units per minute)
float: heart_rate_m1 = 0.5;
float: brain_rate_m1 = 0.8;
float: heart_rate_m2 = 0.3;
float: brain_rate_m2 = 1.0;

float: waste_rate_m1 = 0.3;
float: waste_rate_m2 = 0.5;

float: heart_max = 8.0;   % at most to heart
float: brain_min = 4.0;   % at least to brain

% Simple safe upper bounds for minutes (derived from heart limit)
% minutes_m1 <= heart_max/heart_rate_m1 = 16
% minutes_m2 <= heart_max/heart_rate_m2 ~= 26.6667
var 0.0..16.0: minutes_m1;
var 0.0..26.6666667: minutes_m2;

% Objective expression
var float: total_waste = waste_rate_m1 * minutes_m1 + waste_rate_m2 * minutes_m2;

% Constraints
constraint heart_rate_m1 * minutes_m1 + heart_rate_m2 * minutes_m2 <= heart_max;
constraint brain_rate_m1 * minutes_m1 + brain_rate_m2 * minutes_m2 >= brain_min;

solve minimize total_waste;

output [
  "minutes_m1 = ", show(minutes_m1), "\n",
  "minutes_m2 = ", show(minutes_m2), "\n",
  "total_waste = ", show(total_waste), "\n"
];