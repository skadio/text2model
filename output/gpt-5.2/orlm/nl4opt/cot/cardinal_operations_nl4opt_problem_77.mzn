% Parameters (with values embedded)
float: heart_rate_m1 = 0.5;
float: brain_rate_m1 = 0.8;
float: waste_rate_m1 = 0.3;

float: heart_rate_m2 = 0.3;
float: brain_rate_m2 = 1.0;
float: waste_rate_m2 = 0.5;

float: heart_max = 8.0;
float: brain_min = 4.0;

% Variables
var 0.0..100.0: x1; % minutes machine 1 is used
var 0.0..100.0: x2; % minutes machine 2 is used

% Constraints
constraint heart_rate_m1 * x1 + heart_rate_m2 * x2 <= heart_max;
constraint brain_rate_m1 * x1 + brain_rate_m2 * x2 >= brain_min;

% Objective
var float: total_waste = waste_rate_m1 * x1 + waste_rate_m2 * x2;
solve minimize total_waste;