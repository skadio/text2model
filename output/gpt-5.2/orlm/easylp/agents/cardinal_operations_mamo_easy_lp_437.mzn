% Parameters
% Cost per hour
int: doctor_cost = 10;
int: nurse_cost  = 20;

% Care/availability constraint coefficients and RHS
int: care_doc_coeff   = 2;    % coefficient for doctor hours in care constraint
int: care_nurse_coeff = 1;    % coefficient for nurse hours in care constraint
int: care_min         = 50;   % minimum required care effort

int: over_doc_coeff   = 1;    % coefficient for doctor hours in overwork constraint
int: over_nurse_coeff = 3;    % coefficient for nurse hours in overwork constraint
int: over_max         = 150;  % maximum allowed overwork effort

% Difference requirement (doctors must exceed nurses by at least this amount)
int: min_doc_minus_nurse = 10;

% Weekly bounds on hours (nonnegative; safe upper bounds derived from overwork constraint)
int: min_hours = 0;
int: max_doctor_hours = over_max div over_doc_coeff;   % 150
int: max_nurse_hours  = over_max div over_nurse_coeff; % 50

% Variables
var min_hours..max_doctor_hours: doctor_hours; % integer weekly doctor hours
var min_hours..max_nurse_hours:  nurse_hours;  % integer weekly nurse hours

var int: total_cost; % total staffing cost (units)

% Constraints
% Care adequacy constraint: ensure sufficient combined staffing effort
constraint
  care_doc_coeff * doctor_hours + care_nurse_coeff * nurse_hours >= care_min;

% Overwork prevention constraint: limit total weighted workload
constraint
  over_doc_coeff * doctor_hours + over_nurse_coeff * nurse_hours <= over_max;

% Staffing mix constraint: doctors must exceed nurses by at least the specified difference
constraint
  doctor_hours - nurse_hours >= min_doc_minus_nurse;

% Total cost definition: link total_cost to hours and per-hour costs
constraint
  total_cost = doctor_cost * doctor_hours + nurse_cost * nurse_hours;

% Objective
solve minimize total_cost;