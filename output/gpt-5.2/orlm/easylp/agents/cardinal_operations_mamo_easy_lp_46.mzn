% Parameters
int: nurse_cost_per_hour = 7;          % $/hour for a nurse
int: doctor_cost_per_hour = 10;        % $/hour for a doctor

int: min_shift_equivalent_hours = 20;  % minimum required "equivalent hours"
int: max_budget_hours = 60;            % maximum allowed combined-hours (budget limit)

% Variables
var 0..max_budget_hours: nurse_hours;   % integer hours worked by nurses (>= 0)
var 0..max_budget_hours: doctor_hours;  % integer hours worked by doctors (>= 0)

% Total staffing cost (bounded by worst-case max hours for each role)
var 0..(nurse_cost_per_hour*max_budget_hours + doctor_cost_per_hour*max_budget_hours): total_cost;

% Constraints
% Total cost definition (linear cost from hours)
constraint
  total_cost = nurse_cost_per_hour * nurse_hours
             + doctor_cost_per_hour * doctor_hours;

% Minimum service requirement:
% "2 nurse-hours are equivalent to 1 doctor-hour"
constraint
  2 * nurse_hours + doctor_hours >= min_shift_equivalent_hours;

% Budget limitation on combined hours:
% "one nurse and three doctors" combined-hours limit
constraint
  nurse_hours + 3 * doctor_hours <= max_budget_hours;

% Objective
solve minimize total_cost;