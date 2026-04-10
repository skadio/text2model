% Parameters
int: total_patients = 320;              % Patients that must be transported each day
int: amb_capacity = 20;                 % Patients transported per Type II ambulance shift
int: van_capacity = 15;                 % Patients transported per hospital van shift
int: amb_cost = 820;                    % Cost per Type II ambulance shift ($)
int: van_cost = 550;                    % Cost per hospital van shift ($)
float: max_van_fraction = 0.60;         % At most this fraction of shifts can be vans

% Variables
var 0..total_patients: amb_shifts;      % Number of Type II ambulance shifts scheduled
var 0..total_patients: van_shifts;      % Number of hospital van shifts scheduled
var 0..(amb_cost*total_patients + van_cost*total_patients): total_cost; % Total daily cost ($)

% Constraints
% Meet daily transportation demand (at least total_patients moved)
constraint
  amb_capacity * amb_shifts + van_capacity * van_shifts >= total_patients;

% Union limitation: at most max_van_fraction of all shifts are vans
% van_shifts <= max_van_fraction * (amb_shifts + van_shifts)
% Rewritten to avoid float*var: (1-max_van_fraction)*van_shifts <= max_van_fraction*amb_shifts
constraint
  (1.0 - max_van_fraction) * int2float(van_shifts)
  <= max_van_fraction * int2float(amb_shifts);

% Define total cost from scheduled shifts
constraint
  total_cost = amb_cost * amb_shifts + van_cost * van_shifts;

% Objective
solve minimize total_cost;