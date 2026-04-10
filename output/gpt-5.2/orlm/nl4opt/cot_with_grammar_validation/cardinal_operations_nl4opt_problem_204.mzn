% Parameters
int: total_pain = 800;

int: pain_day = 6;
int: sleep_day = 2;

int: pain_night = 5;
int: sleep_night = 5;

int: min_night = 200;
int: min_day_frac_num = 40;  % 40%
int: min_day_frac_den = 100; % denominator for percentage

% Variables
var 0..total_pain: x_day;
var 0..total_pain: x_night;

var 0..(sleep_day * total_pain + sleep_night * total_pain): total_sleep;

% Constraints
constraint pain_day * x_day + pain_night * x_night <= total_pain;

constraint x_night >= min_night;

% At least 40% daytime pills: x_day / (x_day + x_night) >= 0.4
% Cross-multiplied to avoid division:
constraint min_day_frac_den * x_day >= min_day_frac_num * (x_day + x_night);

constraint total_sleep = sleep_day * x_day + sleep_night * x_night;

% Objective
solve minimize total_sleep;