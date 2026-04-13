% Parameters
int: total_pain_medicine = 800;          % Total available units of painkiller medicine

int: pain_per_daytime = 6;              % Pain medicine units per daytime pill
int: sleep_per_daytime = 2;             % Sleep medicine units per daytime pill

int: pain_per_nighttime = 5;            % Pain medicine units per nighttime pill
int: sleep_per_nighttime = 5;           % Sleep medicine units per nighttime pill

float: min_daytime_fraction = 0.40;     % At least this fraction of all pills must be daytime (not used directly)
int: min_nighttime_pills = 200;         % At least this many nighttime pills must be made


% Variables
var 0..(total_pain_medicine div pain_per_daytime): daytime_pills; 
var min_nighttime_pills..(total_pain_medicine div pain_per_nighttime): nighttime_pills;

var 0..total_pain_medicine: total_sleep_medicine;  % Total sleep medicine used (to be minimized)


% Constraints
% Pain medicine availability (cannot exceed total available painkiller units)
constraint
  pain_per_daytime * daytime_pills + pain_per_nighttime * nighttime_pills
  <= total_pain_medicine;

% Minimum fraction of pills that must be daytime pills (at least 40%)
% Cross-multiplied to avoid floats:
% daytime_pills >= 0.40 * (daytime_pills + nighttime_pills)
constraint
  100 * daytime_pills >= 40 * (daytime_pills + nighttime_pills);

% Define total sleep medicine used based on production amounts
constraint
  total_sleep_medicine =
    sleep_per_daytime * daytime_pills + sleep_per_nighttime * nighttime_pills;


% Objective
solve minimize total_sleep_medicine;