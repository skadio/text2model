% Parameters
int: demand = 500;                 % Minimum total production (MW)
int: max_measure1 = 200;           % Upper bound for first regulatory measure
int: min_measure2 = 150;           % Lower bound for second regulatory measure

int: cost_coal = 20;               % $/MW for coal
int: cost_gas = 30;                % $/MW for gas
int: cost_nuclear = 40;            % $/MW for nuclear

% Variables
var 0..demand: coal;               % Coal production (MW), integer and nonnegative
var 0..demand: gas;                % Gas production (MW), integer and nonnegative
var 0..demand: nuclear;            % Nuclear production (MW), integer and nonnegative

% Constraints
% --- Demand satisfaction: total production must meet or exceed demand ---
constraint
  coal + gas + nuclear >= demand;

% --- Regulatory measure 1 (upper bound): avoid fractional coefficients by scaling ---
% 0.5*coal - 0.2*gas + 1*nuclear <= max_measure1
% Multiply by 10: 5*coal - 2*gas + 10*nuclear <= 10*max_measure1
constraint
  5 * coal - 2 * gas + 10 * nuclear <= 10 * max_measure1;

% --- Regulatory measure 2 (lower bound): avoid fractional coefficients by scaling ---
% 1*coal - 1*gas + 0.4*nuclear >= min_measure2
% Multiply by 5: 5*coal - 5*gas + 2*nuclear >= 5*min_measure2
constraint
  5 * coal - 5 * gas + 2 * nuclear >= 5 * min_measure2;

% Objective
solve minimize (cost_coal * coal + cost_gas * gas + cost_nuclear * nuclear);