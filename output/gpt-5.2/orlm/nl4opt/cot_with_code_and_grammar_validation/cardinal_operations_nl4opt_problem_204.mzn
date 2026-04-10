% Parameters
int: total_pain = 800;

int: pain_day = 6;
int: sleep_day = 2;

int: pain_night = 5;
int: sleep_night = 5;

int: min_night = 200;
int: min_day_pct = 40; % percent

% Variables
var 0..total_pain: day_pills;
var min_night..total_pain: night_pills;

% Constraints
constraint pain_day * day_pills + pain_night * night_pills <= total_pain;

% At least 40% of all pills are daytime:
% day_pills >= 0.40 * (day_pills + night_pills)
% Avoid fractions: 100*day >= min_day_pct*(day+night)
constraint 100 * day_pills >= min_day_pct * (day_pills + night_pills);

% Objective
solve minimize sleep_day * day_pills + sleep_night * night_pills;