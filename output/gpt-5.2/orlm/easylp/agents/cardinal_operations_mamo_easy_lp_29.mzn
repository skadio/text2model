% Parameters
% Capacity and restriction coefficients (embedded data)
int: cap_truck = 4;            % contribution per truck to demand capacity
int: cap_van   = 3;            % contribution per van to demand capacity
int: demand_min = 15;          % minimum required total capacity

int: restr_truck = 2;          % coefficient for trucks in road restriction
int: restr_van   = 1;          % coefficient for vans in road restriction
int: restr_max   = 30;         % maximum allowed by road restriction

int: cost_truck = 6;           % daily operating cost per truck ($)
int: cost_van   = 7;           % daily operating cost per van ($)

% Safe upper bounds derived from road restriction constraint
int: max_trucks = restr_max div restr_truck;  % trucks <= 15
int: max_vans   = restr_max div restr_van;    % vans   <= 30

% Variables
var 0..max_trucks: trucks;     % number of trucks assigned (non-negative integer)
var 0..max_vans: vans;         % number of vans assigned (non-negative integer)

% Total daily cost ($), bounded using max bounds above
var 0..(cost_truck*max_trucks + cost_van*max_vans): total_cost;

% Constraints
% Demand satisfaction: combined capacity from trucks and vans must meet minimum demand
constraint
  cap_truck * trucks + cap_van * vans >= demand_min;

% Road restriction: weighted sum of vehicles must not exceed maximum allowed
constraint
  restr_truck * trucks + restr_van * vans <= restr_max;

% Total cost definition: compute daily operating cost from chosen numbers of vehicles
constraint
  total_cost = cost_truck * trucks + cost_van * vans;

% Objective
solve minimize total_cost;