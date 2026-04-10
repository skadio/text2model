% Parameters
% Unit costs (USD per unit) for each department
int: cost_T = 500;
int: cost_P = 300;
int: cost_S = 200;
int: cost_R = 100;

% Policy limits on combined allocations (in units)
int: max_TP = 50;   % Technology + Physics <= 50
int: max_SR = 30;   % Sports + Research  <= 30

% Minimum required allocations (in units)
int: min_T = 15;
int: min_P = 10;
int: min_S = 5;
int: min_R = 2;

% Variables
% Integer allocation units to each department (non-negative, whole numbers)
var int: T;  % Technology units
var int: P;  % Physics units
var int: S;  % Sports units
var int: R;  % Research units

% Total cost (USD)
var int: total_cost;

% Constraints
% Enforce non-negativity (and integrality is ensured by var int)
constraint T >= 0 /\ P >= 0 /\ S >= 0 /\ R >= 0;

% Minimum allocation requirements (policy floors)
constraint T >= min_T;
constraint P >= min_P;
constraint S >= min_S;
constraint R >= min_R;

% Combined allocation caps (policy upper limits)
constraint T + P <= max_TP;  % Technology + Physics cap
constraint S + R <= max_SR;  % Sports + Research cap

% Total cost definition (linking decision variables to cost)
constraint total_cost = cost_T * T + cost_P * P + cost_S * S + cost_R * R;

% Objective
solve minimize total_cost;