% Parameters
int: red_available = 80;          % Total units of red liquid available
int: blue_available = 70;         % Total units of blue liquid available
int: smelly_max = 10;             % Maximum allowable units of smelly gas

int: red_per_exp1 = 3;            % Red used per experiment 1
int: blue_per_exp1 = 4;           % Blue used per experiment 1
int: green_per_exp1 = 5;          % Green gas produced per experiment 1
int: smelly_per_exp1 = 1;         % Smelly gas produced per experiment 1

int: red_per_exp2 = 5;            % Red used per experiment 2
int: blue_per_exp2 = 3;           % Blue used per experiment 2
int: green_per_exp2 = 6;          % Green gas produced per experiment 2
int: smelly_per_exp2 = 2;         % Smelly gas produced per experiment 2

% Upper bounds for number of experiments (safe bounds from resources/limits)
int: exp1_ub = min(red_available div red_per_exp1,
                   min(blue_available div blue_per_exp1,
                       smelly_max div smelly_per_exp1));
int: exp2_ub = min(red_available div red_per_exp2,
                   min(blue_available div blue_per_exp2,
                       smelly_max div smelly_per_exp2));

% Variables
var 0..exp1_ub: n_exp1;           % Number of times to run experiment 1
var 0..exp2_ub: n_exp2;           % Number of times to run experiment 2

var 0..(green_per_exp1*exp1_ub + green_per_exp2*exp2_ub): total_green; % Total green gas produced

% Constraints

% Link total green gas to the number of experiments performed
constraint total_green =
  green_per_exp1 * n_exp1 + green_per_exp2 * n_exp2;

% Resource capacity constraints (cannot exceed available liquids)
constraint red_per_exp1 * n_exp1 + red_per_exp2 * n_exp2 <= red_available;
constraint blue_per_exp1 * n_exp1 + blue_per_exp2 * n_exp2 <= blue_available;

% Smelly gas production limit
constraint smelly_per_exp1 * n_exp1 + smelly_per_exp2 * n_exp2 <= smelly_max;

% Objective
solve maximize total_green;