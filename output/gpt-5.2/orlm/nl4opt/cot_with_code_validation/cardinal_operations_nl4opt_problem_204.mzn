% Parameters
int: total_pain = 800;

int: pain_day = 6;
int: sleep_day = 2;

int: pain_night = 5;
int: sleep_night = 5;

float: min_day_fraction = 0.40;
int: min_night = 200;

% Variables
var 0..total_pain div min(pain_day, pain_night): x_day;
var 0..total_pain div min(pain_day, pain_night): x_night;

var 0..(sleep_day * (total_pain div pain_day) + sleep_night * (total_pain div pain_night)): total_sleep;

% Constraints
constraint pain_day * x_day + pain_night * x_night <= total_pain;

constraint x_night >= min_night;

constraint x_day >= ceil(min_day_fraction * (x_day + x_night));

constraint total_sleep = sleep_day * x_day + sleep_night * x_night;

% Objective
solve minimize total_sleep;