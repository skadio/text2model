% Parameters
int: tech_hours_per_shift = 8;         % hours provided by one ultrasound technician shift
int: grad_hours_per_shift = 5;         % hours provided by one graduate researcher shift
int: tech_cost_per_shift  = 300;       % cost of one technician shift ($)
int: grad_cost_per_shift  = 100;       % cost of one graduate researcher shift ($)
int: required_hours       = 500;       % minimum total ultrasound service hours required
int: budget               = 14000;     % maximum total budget ($)
int: tech_to_grad_ratio   = 2;         % must have tech shifts = 2 * grad shifts

% Variables
var 0..(budget div tech_cost_per_shift): tech_shifts;  % number of technician shifts scheduled
var 0..(budget div grad_cost_per_shift): grad_shifts;  % number of graduate researcher shifts scheduled
var 0..(budget div min(tech_cost_per_shift, grad_cost_per_shift)): total_shifts; % total shifts scheduled

% Constraints
% Total shifts definition (used to minimize total number of workers/shifts)
constraint
  total_shifts = tech_shifts + grad_shifts;

% Coverage constraint: ensure enough total ultrasound service hours are provided
constraint
  tech_hours_per_shift * tech_shifts + grad_hours_per_shift * grad_shifts >= required_hours;

% Budget constraint: total cost of scheduled shifts must not exceed available budget
constraint
  tech_cost_per_shift * tech_shifts + grad_cost_per_shift * grad_shifts <= budget;

% Regulatory ratio constraint: technician shifts must be twice graduate researcher shifts
constraint
  tech_shifts = tech_to_grad_ratio * grad_shifts;

% Objective
solve minimize total_shifts;