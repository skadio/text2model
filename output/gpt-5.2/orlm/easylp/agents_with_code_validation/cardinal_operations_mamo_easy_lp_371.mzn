% Parameters
% Workload score per hour for each staff member
int: score_nurse1 = 3;
int: score_nurse2 = 2;
int: score_doctor1 = 4;
int: score_doctor2 = 5;

% Minimum combined hours requirements
int: min_nurse_hours = 10;
int: min_doctor_hours = 8;

% Maximum allowed absolute differences (balance constraints)
int: max_diff_n1_d1 = 4;
int: max_diff_n2_d2 = 3;

% Upper bounds for hours (safe bounds derived from mins + diffs)
int: ub_nurse1_hours = 12;
int: ub_nurse2_hours = 11;
int: ub_doctor1_hours = 8;
int: ub_doctor2_hours = 8;


% Variables
% Hours assigned to each staff member (whole numbers)
var 0..ub_nurse1_hours: hours_nurse1;
var 0..ub_nurse2_hours: hours_nurse2;
var 0..ub_doctor1_hours: hours_doctor1;
var 0..ub_doctor2_hours: hours_doctor2;

% Total workload score (objective value)
var 0..(score_nurse1*ub_nurse1_hours
      + score_nurse2*ub_nurse2_hours
      + score_doctor1*ub_doctor1_hours
      + score_doctor2*ub_doctor2_hours): total_workload_score;


% Constraints
% Link total workload score to assigned hours
constraint
  total_workload_score =
    score_nurse1 * hours_nurse1 +
    score_nurse2 * hours_nurse2 +
    score_doctor1 * hours_doctor1 +
    score_doctor2 * hours_doctor2;

% Minimum combined hours for nurses
constraint
  hours_nurse1 + hours_nurse2 >= min_nurse_hours;

% Minimum combined hours for doctors
constraint
  hours_doctor1 + hours_doctor2 >= min_doctor_hours;

% Balance constraint: Nurse1 vs Doctor1 (absolute difference bounded)
constraint
  abs(hours_nurse1 - hours_doctor1) <= max_diff_n1_d1;

% Balance constraint: Nurse2 vs Doctor2 (absolute difference bounded)
constraint
  abs(hours_nurse2 - hours_doctor2) <= max_diff_n2_d2;


% Objective
solve minimize total_workload_score;