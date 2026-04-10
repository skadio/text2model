% Parameters (with values embedded)
int: total_pain_medicine = 800;

int: pain_day = 6;
int: sleep_day = 2;

int: pain_night = 5;
int: sleep_night = 5;

float: min_day_fraction = 0.40;
int: min_night_pills = 200;

% Variables
var 0..total_pain_medicine div pain_day: x_day;      % number of daytime pills
var 0..total_pain_medicine div pain_night: x_night;  % number of nighttime pills

% Constraints
constraint pain_day * x_day + pain_night * x_night <= total_pain_medicine;
constraint x_night >= min_night_pills;

% At least 40% of pills are daytime: x_day / (x_day + x_night) >= 0.40
% Equivalent (avoid division): 0.6*x_day - 0.4*x_night >= 0  => 3*x_day - 2*x_night >= 0
constraint 3 * x_day >= 2 * x_night;

% Objective
var int: total_sleep_medicine = sleep_day * x_day + sleep_night * x_night;
solve minimize total_sleep_medicine;