% Parameters
int: patients_required = 320;                 % Total patients that must be transported per day

int: amb_capacity = 20;                       % Patients moved per ambulance shift
int: van_capacity = 15;                       % Patients moved per van shift

int: amb_cost = 820;                          % Cost per ambulance shift ($)
int: van_cost = 550;                          % Cost per van shift ($)

float: max_van_share = 0.60;                  % At most this fraction of shifts can be vans

% Derived bounds (safe upper bounds for bounded variable declarations)
int: max_shifts =
  ceil(int2float(patients_required) / int2float(min(amb_capacity, van_capacity)));
% Maximum shifts needed if using only the smaller capacity vehicle

% Variables
var 0..max_shifts: amb_shifts;                % Number of type II ambulance shifts scheduled
var 0..max_shifts: van_shifts;                % Number of hospital van shifts scheduled

var 0..(amb_cost * max_shifts + van_cost * max_shifts): total_cost;  % Total daily cost ($)

% Constraints

% Patient transport requirement: meet or exceed required number of patients
constraint
  amb_capacity * amb_shifts + van_capacity * van_shifts >= patients_required;

% Union limitation: vans can be at most max_van_share of total shifts
% van_shifts / (amb_shifts + van_shifts) <= max_van_share
% Cross-multiplied via float coercions to avoid division by a variable:
constraint
  int2float(van_shifts) <= max_van_share * int2float(amb_shifts + van_shifts);

% Total cost definition
constraint
  total_cost = amb_cost * amb_shifts + van_cost * van_shifts;

% Objective
solve minimize total_cost;