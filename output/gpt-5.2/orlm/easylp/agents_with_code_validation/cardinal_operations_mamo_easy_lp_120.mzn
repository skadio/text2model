% Parameters
int: max_total_services = 200;          % Maximum total services per month
int: min_sightseeing = 50;             % Minimum required local sightseeing tours (X)
int: min_adventure = 30;               % Minimum required adventure activities (Y)
int: cost_sightseeing = 300;           % Cost per sightseeing tour ($)
int: cost_adventure = 500;             % Cost per adventure activity ($)

% Variables
var min_sightseeing..max_total_services: X;   % Number of local sightseeing tours (integer)
var min_adventure..max_total_services: Y;     % Number of adventure activities (integer)
var 0..(max_total_services * max(cost_sightseeing, cost_adventure)): total_cost; % Total monthly operational cost ($)

% Constraints
% Capacity constraint: total number of services cannot exceed monthly maximum
constraint X + Y <= max_total_services;

% Cost definition constraint: compute total monthly operational cost from chosen service levels
constraint total_cost = cost_sightseeing * X + cost_adventure * Y;

% Objective
solve minimize total_cost;