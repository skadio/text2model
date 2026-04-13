% Parameters
int: min_total_hires = 10;              % Minimum total hires across departments
int: max_weighted_capacity = 20;        % Maximum allowed value of (2*X + Y)
int: cost_per_hire_X = 50;              % Onboarding cost per hire in department X
int: cost_per_hire_Y = 30;              % Onboarding cost per hire in department Y

% Variables
var 0..max_weighted_capacity: hires_X;  % Number of hires in department X (integer, nonnegative)
var 0..max_weighted_capacity: hires_Y;  % Number of hires in department Y (integer, nonnegative)
var 0..(cost_per_hire_X*max_weighted_capacity + cost_per_hire_Y*max_weighted_capacity): total_cost;
  % Total onboarding cost (bounded safely from above)

% Constraints
% Staffing requirement: total hires across both departments must be at least the minimum
constraint hires_X + hires_Y >= min_total_hires;

% Capacity/budget limitation: weighted staffing level must not exceed maximum capacity
constraint 2 * hires_X + hires_Y <= max_weighted_capacity;

% Total onboarding cost definition: link total_cost to hires in each department
constraint total_cost = cost_per_hire_X * hires_X + cost_per_hire_Y * hires_Y;

% Objective
solve minimize total_cost;