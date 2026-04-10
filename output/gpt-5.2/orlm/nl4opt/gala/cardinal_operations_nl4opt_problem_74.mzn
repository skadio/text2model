% Morphine pill production optimization (all data embedded)

% Data
int: morphine_total = 3000;     % mg
int: morphine_pain = 10;        % mg per painkiller
int: morphine_sleep = 6;        % mg per sleeping pill

int: dig_pain = 3;              % units per painkiller
int: dig_sleep = 5;             % units per sleeping pill

int: min_pain = 50;             % at least 50 painkillers
int: sleep_percent = 70;        % at least 70% sleeping

% Safe variable bounds from morphine constraint
int: max_pain = morphine_total div morphine_pain;   % if only painkillers
int: max_sleep = morphine_total div morphine_sleep; % if only sleepers

% Decision variables
var 0..max_pain: pain;
var 0..max_sleep: sleep;

% Constraints
constraint morphine_pain * pain + morphine_sleep * sleep <= morphine_total;
constraint pain >= min_pain;

% At least 70% of produced pills are sleeping:
% sleep / (pain+sleep) >= 0.7  <=>  10*sleep >= 7*(pain+sleep)  <=>  3*sleep >= 7*pain
constraint 3 * sleep >= 7 * pain;

% Objective: minimize total digestive medicine used
var 0..(dig_pain*max_pain + dig_sleep*max_sleep): total_dig;
constraint total_dig = dig_pain * pain + dig_sleep * sleep;

solve minimize total_dig;

output [
  "painkillers = ", show(pain), "\n",
  "sleeping = ", show(sleep), "\n",
  "total_pills = ", show(pain + sleep), "\n",
  "morphine_used = ", show(morphine_pain*pain + morphine_sleep*sleep), " mg\n",
  "digestive_used = ", show(total_dig), " units\n"
];