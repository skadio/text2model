% Parameters
% Minimum total staff required
int: min_total_staff = 20;

% Maximum allowed value of (2*doctors - nurses)
int: max_diff = 10;

% Daily costs
int: cost_doctor = 10;
int: cost_nurse  = 5;

% Variables
% Number of doctors and nurses (non-negative integers)
var 0..min_total_staff: doctors;
var 0..min_total_staff: nurses;

% Total daily cost (upper bound based on max staff bounds and costs)
var 0..(cost_doctor * min_total_staff + cost_nurse * min_total_staff): total_cost;

% Constraints
% Meet minimum total staffing requirement
constraint doctors + nurses >= min_total_staff;

% Staffing mix requirement: (2*doctors - nurses) <= max_diff
constraint 2 * doctors - nurses <= max_diff;

% Define total daily cost
constraint total_cost = cost_doctor * doctors + cost_nurse * nurses;

% Objective
solve minimize total_cost;