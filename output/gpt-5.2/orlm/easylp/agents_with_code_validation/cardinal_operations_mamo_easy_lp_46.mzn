% Parameters
int: nurse_cost_per_hour = 7;        % $/hour for a nurse
int: doctor_cost_per_hour = 10;      % $/hour for a doctor

int: required_equiv_hours = 20;      % required "equivalent hours" for the shift
int: nurse_equiv_factor = 2;         % 2 nurse-hours = 1 equivalent-hour
int: doctor_equiv_factor = 1;        % 1 doctor-hour = 1 equivalent-hour

int: max_budget_combo_hours = 60;    % max combined hours for (1 nurse + 3 doctors)

% Variables
var 0..max_budget_combo_hours: nurse_hours;   % whole hours assigned to nurses
var 0..max_budget_combo_hours: doctor_hours;  % whole hours assigned to doctors

var 0..(nurse_cost_per_hour * max_budget_combo_hours
      + doctor_cost_per_hour * max_budget_combo_hours): total_cost; % total staffing cost

% Constraints
% Shift coverage constraint: meet at least the required equivalent-hours
% (2 nurse-hours = 1 equivalent-hour; 1 doctor-hour = 1 equivalent-hour)
constraint
  nurse_hours div nurse_equiv_factor + doctor_hours >= required_equiv_hours;

% Budget limitation constraint: combined hours for (1 nurse + 3 doctors) cannot exceed limit
constraint
  nurse_hours + 3 * doctor_hours <= max_budget_combo_hours;

% Cost accounting constraint: define total staffing cost from assigned hours
constraint
  total_cost = nurse_cost_per_hour * nurse_hours + doctor_cost_per_hour * doctor_hours;

% Objective
solve minimize total_cost;