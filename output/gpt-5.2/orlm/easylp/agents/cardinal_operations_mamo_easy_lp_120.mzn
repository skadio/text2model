% Parameters
int: max_total_services = 200;          % Maximum total services allowed per month
int: min_sightseeing = 50;              % Minimum number of local sightseeing tours (X)
int: min_adventure = 30;                % Minimum number of adventure activities (Y)
int: cost_sightseeing = 300;            % Cost per sightseeing tour
int: cost_adventure = 500;              % Cost per adventure activity

% Variables
var min_sightseeing..max_total_services: X;   % Number of local sightseeing tours (integer)
var min_adventure..max_total_services: Y;     % Number of adventure activities (integer)
var 0..(cost_sightseeing*max_total_services + cost_adventure*max_total_services): total_cost;
                                              % Total monthly operational cost (integer)

% Constraints
% Service capacity constraint: total services cannot exceed the monthly maximum
constraint
  X + Y <= max_total_services;

% Minimum service level constraints: enforce minimum offerings for each service
constraint
  X >= min_sightseeing;
constraint
  Y >= min_adventure;

% Cost definition constraint: compute total operational cost from service counts
constraint
  total_cost = cost_sightseeing * X + cost_adventure * Y;

% Objective
solve minimize total_cost;