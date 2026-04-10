% Pill production optimization (data embedded)

int: total_painkiller = 800;

int: pain_day = 6;
int: sleep_day = 2;

int: pain_night = 5;
int: sleep_night = 5;

float: min_day_fraction = 0.40;
int: min_night = 200;

% Decision variables: number of pills
var 0..(total_painkiller div pain_day): day;
var 0..(total_painkiller div pain_night): night;

% Total sleep medicine used
var 0..100000: total_sleep = sleep_day * day + sleep_night * night;

% Painkiller availability constraint
constraint pain_day * day + pain_night * night <= total_painkiller;

% At least 200 nighttime pills
constraint night >= min_night;

% At least 40% of all pills are daytime:
% day >= 0.4 * (day + night)  <=>  0.6*day >= 0.4*night  <=>  3*day >= 2*night
constraint 3 * day >= 2 * night;

solve minimize total_sleep;

output [
  "day = ", show(day), "\n",
  "night = ", show(night), "\n",
  "total_sleep = ", show(total_sleep), "\n",
  "pain_used = ", show(pain_day*day + pain_night*night), " / ", show(total_painkiller), "\n"
];