% Parameters
% Units of medicines per pill type
int: sleep_A = 3;          % sleep-inducing units in one pill A
int: antiinf_A = 5;        % anti-inflammatory units in one pill A
int: sleep_B = 6;          % sleep-inducing units in one pill B
int: antiinf_B = 1;        % anti-inflammatory units in one pill B

% Costs per pill type
int: cost_A = 4;           % cost of one pill A ($)
int: cost_B = 5;           % cost of one pill B ($)

% Minimum required total units
int: min_sleep = 40;       % minimum sleep-inducing units required
int: min_antiinf = 50;     % minimum anti-inflammatory units required

% Variables
var 0..1000: num_A;         % number of pill A to take (nonnegative integer)
var 0..1000: num_B;         % number of pill B to take (nonnegative integer)
var 0..1000000: total_cost; % total cost ($)

% Constraints
% Meet minimum required sleep-inducing units
constraint sleep_A * num_A + sleep_B * num_B >= min_sleep;

% Meet minimum required anti-inflammatory units
constraint antiinf_A * num_A + antiinf_B * num_B >= min_antiinf;

% Define total cost
constraint total_cost = cost_A * num_A + cost_B * num_B;

% Objective
solve minimize total_cost;