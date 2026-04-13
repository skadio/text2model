% Parameters
int: total_pain_medicine = 800;                 % Total available units of painkiller medicine

int: pain_per_day_pill = 6;                     % Pain medicine units required per daytime pill
int: sleep_per_day_pill = 2;                    % Sleep medicine units required per daytime pill

int: pain_per_night_pill = 5;                   % Pain medicine units required per nighttime pill
int: sleep_per_night_pill = 5;                  % Sleep medicine units required per nighttime pill

float: min_day_fraction = 0.40;                 % At least this fraction of all pills must be daytime
int: min_night_pills = 200;                     % At least this many nighttime pills must be produced

% Variables
var 0..(total_pain_medicine div pain_per_day_pill): day_pills;     
  % Number of daytime pills produced

var min_night_pills..(total_pain_medicine div pain_per_night_pill): night_pills; 
  % Number of nighttime pills produced

var 0..(sleep_per_day_pill*(total_pain_medicine div pain_per_day_pill)
      + sleep_per_night_pill*(total_pain_medicine div pain_per_night_pill)): total_sleep_medicine;
  % Total sleep medicine used

% Constraints
% Pain medicine availability (cannot exceed total stock)
constraint
  pain_per_day_pill * day_pills + pain_per_night_pill * night_pills <= total_pain_medicine;

% Minimum fraction of daytime pills:
% day_pills >= min_day_fraction * (day_pills + night_pills)
% Integer-safe equivalent for 40%: 3*day_pills >= 2*night_pills
constraint
  3 * day_pills >= 2 * night_pills;

% Total sleep medicine used is determined by production quantities
constraint
  total_sleep_medicine =
    sleep_per_day_pill * day_pills + sleep_per_night_pill * night_pills;

% Objective
solve minimize total_sleep_medicine;