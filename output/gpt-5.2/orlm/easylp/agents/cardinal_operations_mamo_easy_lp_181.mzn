% Parameters
% Demand (minimum total production, MW)
int: demand = 500;

% Constraint 1 coefficients for (coal, gas, nuclear):
% 0.5*coal - 0.2*gas + 1.0*nuclear <= 200
float: a1_coal = 0.5;
float: a1_gas  = -0.2;
float: a1_nuc  = 1.0;
float: b1 = 200.0;

% Constraint 2 coefficients for (coal, gas, nuclear):
% 1.0*coal - 1.0*gas + 0.4*nuclear >= 150
float: a2_coal = 1.0;
float: a2_gas  = -1.0;
float: a2_nuc  = 0.4;
float: b2 = 150.0;

% Costs ($/MW)
int: cost_coal = 20;
int: cost_gas  = 30;
int: cost_nuc  = 40;

% Derived scaling factor to avoid floating point constraints (LCM of 2,5,10 = 10)
int: scale = 10;


% Variables
% Production quantities (MW), whole numbers and nonnegative
var 0..100000: coal;    % MW from coal
var 0..100000: gas;     % MW from gas
var 0..100000: nuclear; % MW from nuclear

% Total cost (bounded explicitly for linear objective)
var 0..(cost_coal + cost_gas + cost_nuc) * 100000: total_cost;


% Constraints
% Total cost definition (kept linear and integer)
constraint total_cost = cost_coal * coal + cost_gas * gas + cost_nuc * nuclear;

% Demand satisfaction: total production must meet or exceed required demand
constraint coal + gas + nuclear >= demand;

% Environmental/safety constraint 1 (scaled by `scale` = 10 to avoid floats):
% 0.5*coal - 0.2*gas + 1.0*nuclear <= 200
% => 5*coal - 2*gas + 10*nuclear <= 2000
constraint 5 * coal - 2 * gas + 10 * nuclear <= 2000;

% Environmental/safety constraint 2 (scaled by `scale` = 10 to avoid floats):
% 1.0*coal - 1.0*gas + 0.4*nuclear >= 150
% => 10*coal - 10*gas + 4*nuclear >= 1500
constraint 10 * coal - 10 * gas + 4 * nuclear >= 1500;


% Objective
solve minimize total_cost;