% Parameters
int: red_available = 80;          % Total units of red liquid available
int: blue_available = 70;         % Total units of blue liquid available
int: smelly_max = 10;             % Maximum units of smelly gas allowed

int: red_req_exp1 = 3;            % Red units required per experiment 1
int: blue_req_exp1 = 4;           % Blue units required per experiment 1
int: green_prod_exp1 = 5;         % Green gas produced per experiment 1
int: smelly_prod_exp1 = 1;        % Smelly gas produced per experiment 1

int: red_req_exp2 = 5;            % Red units required per experiment 2
int: blue_req_exp2 = 3;           % Blue units required per experiment 2
int: green_prod_exp2 = 6;         % Green gas produced per experiment 2
int: smelly_prod_exp2 = 2;        % Smelly gas produced per experiment 2

% Simple safe upper bounds for number of experiments based on resource limits
int: exp1_ub = min(red_available div red_req_exp1, blue_available div blue_req_exp1);
int: exp2_ub = min(red_available div red_req_exp2, blue_available div blue_req_exp2);

% Variables
var 0..exp1_ub: exp1_count;       % Number of times to perform experiment 1
var 0..exp2_ub: exp2_count;       % Number of times to perform experiment 2

var 0..(green_prod_exp1 * exp1_ub + green_prod_exp2 * exp2_ub): total_green;  % Total green gas produced
var 0..smelly_max: total_smelly;  % Total smelly gas produced (bounded by max)

% Constraints

% Link total production variables to experiment counts
constraint total_green =
  green_prod_exp1 * exp1_count + green_prod_exp2 * exp2_count;

constraint total_smelly =
  smelly_prod_exp1 * exp1_count + smelly_prod_exp2 * exp2_count;

% Resource capacity constraints (do not exceed available liquids)
constraint red_req_exp1 * exp1_count + red_req_exp2 * exp2_count <= red_available;

constraint blue_req_exp1 * exp1_count + blue_req_exp2 * exp2_count <= blue_available;

% Smelly gas limit constraint
constraint total_smelly <= smelly_max;

% Objective
solve maximize total_green;