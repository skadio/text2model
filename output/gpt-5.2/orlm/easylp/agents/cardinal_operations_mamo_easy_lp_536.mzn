% Parameters
% Unit costs per acre for each crop
int: cost_wheat = 10;
int: cost_corn = 20;
int: cost_soybean = 30;

% Land/rotation/market constraints
int: max_wheat_plus_corn = 1000;
int: max_corn_plus_soybean = 1500;
int: min_wheat_plus_soybean = 500;
int: min_wheat_minus_corn = 200;

% Specific bounds on crop allocations (assume non-negative acres)
int: min_wheat_acres = 0;
int: min_corn_acres = 0;
int: min_soybean_acres = 0;

% A safe upper bound derived from the stated limits (keeps variables bounded)
int: max_acres = max(max_wheat_plus_corn, max_corn_plus_soybean);

% Variables
var min_wheat_acres..max_acres: acres_wheat;      % integer acres of Wheat
var min_corn_acres..max_acres: acres_corn;        % integer acres of Corn
var min_soybean_acres..max_acres: acres_soybean;  % integer acres of Soybean

% Total cost (unit cost per acre)
var int: total_cost =
    cost_wheat * acres_wheat
  + cost_corn * acres_corn
  + cost_soybean * acres_soybean;

% Constraints

% --- Land/market upper-bound constraints ---
constraint acres_wheat + acres_corn <= max_wheat_plus_corn;          % Wheat + Corn cannot exceed limit
constraint acres_corn + acres_soybean <= max_corn_plus_soybean;      % Corn + Soybean cannot exceed limit

% --- Rotation/market minimum requirement ---
constraint acres_wheat + acres_soybean >= min_wheat_plus_soybean;    % Wheat + Soybean must be at least minimum

% --- Relative allocation constraint ---
constraint acres_wheat - acres_corn >= min_wheat_minus_corn;         % Wheat must exceed Corn by at least given margin

% Objective
solve minimize total_cost;