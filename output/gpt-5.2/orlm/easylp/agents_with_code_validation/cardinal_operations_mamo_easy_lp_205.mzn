% Parameters
% Cost per staff member in each role
int: cost_doctor = 10;
int: cost_nurse = 20;
int: cost_technician = 30;

% Constraint coefficients and bounds
int: min_service_units = 50;     % 2*doctors + 3*nurses >= 50
int: max_total_staff = 100;      % doctors + nurses + technicians <= 100
int: min_tech_minus_nurse = 10;  % technicians - nurses >= 10


% Variables
var 0..max_total_staff: doctors;      % number of doctors (nonnegative integer)
var 0..max_total_staff: nurses;       % number of nurses (nonnegative integer)
var 0..max_total_staff: technicians;  % number of technicians (nonnegative integer)

% Upper bound: if all staff were technicians (most expensive), cost <= 30*100 = 3000
var 0..(cost_technician * max_total_staff): total_cost;


% Constraints
% Link total_cost to staffing decision variables (linear cost definition)
constraint
  total_cost = cost_doctor * doctors
             + cost_nurse * nurses
             + cost_technician * technicians;

% Minimum service coverage requirement: 2*doctors + 3*nurses >= min_service_units
constraint
  2 * doctors + 3 * nurses >= min_service_units;

% Maximum total staff limit: doctors + nurses + technicians <= max_total_staff
constraint
  doctors + nurses + technicians <= max_total_staff;

% Operational requirement: technicians - nurses >= min_tech_minus_nurse
constraint
  technicians - nurses >= min_tech_minus_nurse;


% Objective
solve minimize total_cost;