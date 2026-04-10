% Parameters
% Minimum total staff required
int: min_total_staff = 100;

% Maximum allowed difference between Doctors and Nurses: |D - N| <= 10
int: max_diff_doctor_nurse = 10;

% Minimum allowed (Technicians - Nurses): (T - N) >= -5
int: min_diff_tech_nurse = -5;

% Cost per staff member in each role
int: cost_doctor = 50;
int: cost_nurse = 30;
int: cost_technician = 20;


% Variables
% Number of Doctors, Nurses, Technicians (non-negative integers)
var 0..100000: doctors;
var 0..100000: nurses;
var 0..100000: technicians;

% Total staffing cost (integer, bounded for linear expressions)
var 0..10000000: total_cost;


% Constraints
% Total staff requirement: doctors + nurses + technicians >= minimum required
constraint
  doctors + nurses + technicians >= min_total_staff;

% Balance constraint between Doctors and Nurses: |doctors - nurses| <= max_diff_doctor_nurse
constraint
  abs(doctors - nurses) <= max_diff_doctor_nurse;

% Operational efficiency constraint between Technicians and Nurses: (technicians - nurses) >= min_diff_tech_nurse
constraint
  technicians - nurses >= min_diff_tech_nurse;

% Define total cost from role counts and per-role costs
constraint
  total_cost = cost_doctor * doctors
             + cost_nurse * nurses
             + cost_technician * technicians;


% Objective
solve minimize total_cost;