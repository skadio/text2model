% Parameters
int: cost_personal = 550;            % Production cost per personal license
int: cost_commercial = 2000;         % Production cost per commercial license
int: profit_personal = 450;          % Profit per personal license
int: profit_commercial = 1200;       % Profit per commercial license
int: max_total_licenses = 300;       % Maximum combined licenses sold per month
int: max_budget = 400000;            % Maximum total spending allowed

% Variables
var 0..max_total_licenses: n_personal;    % Number of personal licenses to produce
var 0..max_total_licenses: n_commercial;  % Number of commercial licenses to produce

% Constraints
% Demand / capacity constraint: total licenses sold/produced cannot exceed monthly limit
constraint
  n_personal + n_commercial <= max_total_licenses;

% Budget constraint: total production spending cannot exceed the maximum budget
constraint
  cost_personal * n_personal + cost_commercial * n_commercial <= max_budget;

% Objective
solve maximize profit_personal * n_personal + profit_commercial * n_commercial;