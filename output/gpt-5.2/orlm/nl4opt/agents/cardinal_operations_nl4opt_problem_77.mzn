% Parameters
% Medicine delivery rates (units per minute)
float: heart_rate_m1 = 0.5;     % machine 1 -> heart
float: brain_rate_m1 = 0.8;     % machine 1 -> brain
float: heart_rate_m2 = 0.3;     % machine 2 -> heart
float: brain_rate_m2 = 1.0;     % machine 2 -> brain

% Waste production rates (units per minute)
float: waste_rate_m1 = 0.3;     % machine 1 waste
float: waste_rate_m2 = 0.5;     % machine 2 waste

% Requirements / limits
float: heart_max = 8.0;         % at most this much to heart
float: brain_min = 4.0;         % at least this much to brain

% Variables
var float: minutes_m1;          % minutes to run machine 1
var float: minutes_m2;          % minutes to run machine 2
var float: total_waste;         % total waste produced

% Constraints
% Non-negativity bounds (machines cannot be run for negative time)
constraint minutes_m1 >= 0.0;
constraint minutes_m2 >= 0.0;

% Heart medicine limit (at most heart_max units delivered to heart)
constraint heart_rate_m1 * minutes_m1 + heart_rate_m2 * minutes_m2 <= heart_max;

% Brain medicine requirement (at least brain_min units delivered to brain)
constraint brain_rate_m1 * minutes_m1 + brain_rate_m2 * minutes_m2 >= brain_min;

% Total waste produced (definition of total_waste variable)
constraint total_waste = waste_rate_m1 * minutes_m1 + waste_rate_m2 * minutes_m2;

% Objective
solve minimize total_waste;