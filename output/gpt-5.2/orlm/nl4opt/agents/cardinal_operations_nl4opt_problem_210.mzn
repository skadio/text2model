% Parameters
int: sleep_per_A = 3;          % units of sleep-inducing medicine in pill A
int: antiinf_per_A = 5;        % units of anti-inflammatory medicine in pill A
int: sleep_per_B = 6;          % units of sleep-inducing medicine in pill B
int: antiinf_per_B = 1;        % units of anti-inflammatory medicine in pill B

int: cost_A = 4;               % cost per pill A ($)
int: cost_B = 5;               % cost per pill B ($)

int: min_sleep = 40;           % minimum required sleep-inducing units
int: min_antiinf = 50;         % minimum required anti-inflammatory units

% Variables
var 0..1000: xA;               % number of pill A to consume (non-negative integer)
var 0..1000: xB;               % number of pill B to consume (non-negative integer)
var 0..100000: total_cost;     % total cost to minimize ($)

% Constraints
% Link total cost to decision variables
constraint
  total_cost = cost_A * xA + cost_B * xB;

% Meet minimum sleep-inducing medicine requirement
constraint
  sleep_per_A * xA + sleep_per_B * xB >= min_sleep;

% Meet minimum anti-inflammatory medicine requirement
constraint
  antiinf_per_A * xA + antiinf_per_B * xB >= min_antiinf;

% Objective
solve minimize total_cost;