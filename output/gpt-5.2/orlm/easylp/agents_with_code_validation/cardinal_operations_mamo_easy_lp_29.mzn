% Parameters
% All data embedded directly in the model (no .dzn expected)
int: cap_truck_coeff = 4;        % coefficient of trucks in capacity constraint
int: cap_van_coeff   = 3;        % coefficient of vans in capacity constraint
int: demand_min      = 15;       % minimum required capacity units

int: road_truck_coeff = 2;       % coefficient of trucks in road restriction
int: road_van_coeff   = 1;       % coefficient of vans in road restriction
int: road_max         = 30;      % maximum allowed road units

int: cost_truck = 6;             % daily operating cost per truck ($)
int: cost_van   = 7;             % daily operating cost per van ($)

% Variables
var 0..road_max: trucks;         % number of trucks assigned to route X (non-negative integer)
var 0..road_max: vans;           % number of vans assigned to route Y (non-negative integer)
var 0..(cost_truck*road_max + cost_van*road_max): total_cost; % total daily cost ($, integer)

% Constraints
% Demand / capacity requirement: 4*trucks + 3*vans >= 15
constraint
  cap_truck_coeff * trucks + cap_van_coeff * vans >= demand_min;

% Road restriction: 2*trucks + 1*vans <= 30
constraint
  road_truck_coeff * trucks + road_van_coeff * vans <= road_max;

% Total cost definition: total_cost = 6*trucks + 7*vans
constraint
  total_cost = cost_truck * trucks + cost_van * vans;

% Objective
solve minimize total_cost;