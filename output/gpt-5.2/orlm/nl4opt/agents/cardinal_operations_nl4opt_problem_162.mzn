% Parameters
int: tech_hours_per_shift = 8;          % Hours provided by one ultrasound technician shift
int: grad_hours_per_shift = 5;          % Hours provided by one graduate researcher shift
int: tech_pay_per_shift   = 300;        % Cost of one ultrasound technician shift ($)
int: grad_pay_per_shift   = 100;        % Cost of one graduate researcher shift ($)

int: required_total_hours = 500;        % Minimum total ultrasound service hours required
int: total_budget         = 14000;      % Maximum total budget available ($)

int: tech_to_grad_ratio   = 2;          % Regulation: technician shifts = 2 * grad shifts

% Useful derived bounds (integer-safe)
int: max_tech_shifts = total_budget div tech_pay_per_shift;  % Max tech shifts if only tech hired
int: max_grad_shifts = total_budget div grad_pay_per_shift;  % Max grad shifts if only grads hired

% Variables
var 0..max_tech_shifts: tech_shifts;    % Number of ultrasound technician shifts to schedule
var 0..max_grad_shifts: grad_shifts;    % Number of graduate researcher shifts to schedule

var 0..(max_tech_shifts + max_grad_shifts): total_shifts; % Total number of shifts (objective proxy)

% Constraints
% Link total_shifts to the decision variables (total number of scheduled shifts)
constraint
  total_shifts = tech_shifts + grad_shifts;

% Regulation constraint: must be twice as many technician shifts as graduate researcher shifts
constraint
  tech_shifts = tech_to_grad_ratio * grad_shifts;

% Coverage constraint: total ultrasound hours provided must meet or exceed required hours
constraint
  tech_hours_per_shift * tech_shifts + grad_hours_per_shift * grad_shifts >= required_total_hours;

% Budget constraint: total pay for scheduled shifts must not exceed the available budget
constraint
  tech_pay_per_shift * tech_shifts + grad_pay_per_shift * grad_shifts <= total_budget;

% Objective
solve minimize total_shifts;