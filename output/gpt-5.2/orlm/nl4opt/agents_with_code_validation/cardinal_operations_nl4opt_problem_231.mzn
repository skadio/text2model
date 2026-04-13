% Parameters
int: cost_personal     = 550;      % production cost per personal license
int: cost_commercial   = 2000;     % production cost per commercial license
int: profit_personal   = 450;      % profit per personal license
int: profit_commercial = 1200;     % profit per commercial license
int: max_total_licenses = 300;     % max combined licenses sold per month
int: max_budget        = 400000;   % maximum allowed total spending

% Variables
var 0..max_total_licenses: num_personal;    % number of personal licenses to produce
var 0..max_total_licenses: num_commercial;  % number of commercial licenses to produce

% Constraints
% Total demand/capacity constraint: combined licenses sold per month is limited
constraint num_personal + num_commercial <= max_total_licenses;

% Budget constraint: total production spending must not exceed the available budget
constraint cost_personal * num_personal + cost_commercial * num_commercial <= max_budget;

% Objective
solve maximize profit_personal * num_personal + profit_commercial * num_commercial;

% (Optional) Output for readability
output [
  "num_personal = ", show(num_personal), "\n",
  "num_commercial = ", show(num_commercial), "\n",
  "total_cost = ", show(cost_personal * num_personal + cost_commercial * num_commercial), "\n",
  "total_profit = ", show(profit_personal * num_personal + profit_commercial * num_commercial), "\n"
];