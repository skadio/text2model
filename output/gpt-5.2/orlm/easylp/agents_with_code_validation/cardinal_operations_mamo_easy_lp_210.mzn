% Parameters
% Staffing roles (fixed to 3 roles: Doctor, Nurse, Technician)
set of int: ROLES = 1..3;

% Minimum total staff required
int: min_total_staff = 100;

% Cost per staff member for each role (Doctor, Nurse, Technician)
array[ROLES] of int: cost_per_person = [50, 30, 20];

% Maximum allowed absolute difference between Doctors and Nurses
int: max_abs_diff_doctor_nurse = 10;

% Minimum allowed (Technicians - Nurses) difference
int: min_diff_technician_nurse = -5;

% Role indices for clarity
int: DOCTOR = 1;
int: NURSE = 2;
int: TECHNICIAN = 3;

% Variables
% Number of staff allocated to each role (whole persons, nonnegative)
array[ROLES] of var 0..1000: staff;

% Total staffing cost (integer because costs and staff are integers)
var 0..(1000 * max(cost_per_person)): total_cost;

% Constraints
% --- Total staffing requirement ---
% Ensure the hospital staffs at least the minimum required personnel.
constraint
  sum(r in ROLES)(staff[r]) >= min_total_staff;

% --- Balance between Doctors and Nurses ---
% The absolute difference between Doctors and Nurses must not exceed the allowed maximum.
constraint
  abs(staff[DOCTOR] - staff[NURSE]) <= max_abs_diff_doctor_nurse;

% --- Difference between Technicians and Nurses ---
% Ensure Technicians - Nurses is not less than the minimum allowed difference.
constraint
  staff[TECHNICIAN] - staff[NURSE] >= min_diff_technician_nurse;

% --- Total cost definition ---
% Define total_cost as the sum of per-role staffing costs.
constraint
  total_cost = sum(r in ROLES)(cost_per_person[r] * staff[r]);

% Objective
solve minimize total_cost;