% Pharmaceutical pill production - minimize sleep medicine usage

% Data (embedded)
int: total_painkiller = 800;

int: pain_day = 6;
int: sleep_day = 2;

int: pain_night = 5;
int: sleep_night = 5;

float: min_day_fraction = 0.40;
int: min_night_pills = 200;

% Decision variables
var 0..total_painkiller: day_pills;
var 0..total_painkiller: night_pills;

% Painkiller availability constraint
constraint pain_day * day_pills + pain_night * night_pills <= total_painkiller;

% At least 200 nighttime pills
constraint night_pills >= min_night_pills;

% At least 40% of the pills are daytime:
% day >= 0.4*(day+night)  <=>  3*day >= 2*night
constraint 3 * day_pills >= 2 * night_pills;

% Objective: minimize total sleep medicine used
var int: total_sleep = sleep_day * day_pills + sleep_night * night_pills;
solve minimize total_sleep;

output [
  "day_pills=", show(day_pills), "\n",
  "night_pills=", show(night_pills), "\n",
  "total_sleep=", show(total_sleep), "\n",
  "total_pain_used=", show(pain_day*day_pills + pain_night*night_pills), "\n"
];