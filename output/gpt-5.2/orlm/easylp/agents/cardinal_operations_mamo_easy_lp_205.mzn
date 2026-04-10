% Parameters
% Unit costs (USD per staff member)
int: cost_doctor = 10;
int: cost_nurse = 20;
int: cost_technician = 30;

% Constraint coefficients / limits
int: min_work_units = 50;          % 2*doctors + 3*nurses >= 50
int: max_total_staff = 100;        % doctors + nurses + technicians <= 100
int: min_tech_minus_nurse = 10;    % technicians - nurses >= 10


% Variables
% Staffing decision variables (whole individuals)
var 0..max_total_staff: doctors;
var 0..max_total_staff: nurses;
var 0..max_total_staff: technicians;

% Total cost (upper bound based on max staff and max unit cost)
var 0..(max_total_staff * max(cost_doctor, max(cost_nurse, cost_technician))): total_cost;


% Constraints
% Staffing requirement: ensure sufficient combined work units
constraint
  2 * doctors + 3 * nurses >= min_work_units;

% Total staffing cap: cannot exceed maximum allowed staff
constraint
  doctors + nurses + technicians <= max_total_staff;

% Operational requirement: technicians must exceed nurses by at least a minimum margin
constraint
  technicians - nurses >= min_tech_minus_nurse;

% Define total cost from staffing levels and unit costs
constraint
  total_cost = cost_doctor * doctors
             + cost_nurse * nurses
             + cost_technician * technicians;


% Objective
solve minimize total_cost;