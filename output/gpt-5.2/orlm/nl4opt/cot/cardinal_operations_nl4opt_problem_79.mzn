% Parameters (with values embedded)
float: legs_per_dose_1 = 0.5;
float: back_per_dose_1 = 0.8;
float: sleep_per_dose_1 = 0.3;

float: legs_per_dose_2 = 0.7;
float: back_per_dose_2 = 0.4;
float: sleep_per_dose_2 = 0.6;

float: max_sleep = 8.0;
float: min_legs = 4.0;

% Variables
var 0..26: x1; % doses of pain killer 1
var 0..13: x2; % doses of pain killer 2
var float: total_back;

% Constraints
constraint sleep_per_dose_1 * int2float(x1) + sleep_per_dose_2 * int2float(x2) <= max_sleep;
constraint legs_per_dose_1 * int2float(x1) + legs_per_dose_2 * int2float(x2) >= min_legs;

constraint total_back = back_per_dose_1 * int2float(x1) + back_per_dose_2 * int2float(x2);

% Objective
solve maximize total_back;