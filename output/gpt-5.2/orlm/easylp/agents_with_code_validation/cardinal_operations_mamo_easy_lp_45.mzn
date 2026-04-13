% Parameters
% Cost per shift (in dollars)
int: cost_doctor = 10;
int: cost_nurse  = 20;

% Staffing requirement bounds
int: min_total_staff = 50;      % doctors + nurses >= 50
int: max_weighted_staff = 120;  % 2*doctors + nurses <= 120

% Variables
var 0..max_weighted_staff: doctors; % number of doctors (non-negative integer)
var 0..max_weighted_staff: nurses;  % number of nurses (non-negative integer)

% Total cost per shift (dollars)
var 0..(cost_doctor*max_weighted_staff + cost_nurse*max_weighted_staff): total_cost;

% Constraints
% Link total_cost to staffing decisions (linear cost calculation)
constraint
  total_cost = cost_doctor * doctors + cost_nurse * nurses;

% Minimum staffing level requirement (doctors + nurses)
constraint
  doctors + nurses >= min_total_staff;

% Maximum weighted staffing limit (2*doctors + nurses)
constraint
  2 * doctors + nurses <= max_weighted_staff;

% Objective
solve minimize total_cost;