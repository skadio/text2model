% Parameters
% Workload score per hour for each staff member (fixed from description)
int: score_nurse1  = 3;
int: score_nurse2  = 2;
int: score_doctor1 = 4;
int: score_doctor2 = 5;

% Minimum combined hours requirements
int: min_nurse_hours  = 10;
int: min_doctor_hours = 8;

% Max allowed hour differences (balance constraints)
int: max_diff_n1_d1 = 4;
int: max_diff_n2_d2 = 3;

% Upper bound for hours (keeps variables bounded)
int: max_hours = 20;

% Variables
var 0..max_hours: hours_nurse1;   % hours assigned to Nurse1 (integer, nonnegative)
var 0..max_hours: hours_nurse2;   % hours assigned to Nurse2 (integer, nonnegative)
var 0..max_hours: hours_doctor1;  % hours assigned to Doctor1 (integer, nonnegative)
var 0..max_hours: hours_doctor2;  % hours assigned to Doctor2 (integer, nonnegative)

var int: total_workload_score;    % total workload score to minimize


% Constraints
% Link total workload score to assigned hours (linear workload computation)
constraint total_workload_score =
    score_nurse1  * hours_nurse1 +
    score_nurse2  * hours_nurse2 +
    score_doctor1 * hours_doctor1 +
    score_doctor2 * hours_doctor2;

% Minimum combined nurse hours requirement
constraint hours_nurse1 + hours_nurse2 >= min_nurse_hours;

% Minimum combined doctor hours requirement
constraint hours_doctor1 + hours_doctor2 >= min_doctor_hours;

% Balance constraint: difference between Nurse1 and Doctor1 hours must not exceed max_diff_n1_d1
constraint abs(hours_nurse1 - hours_doctor1) <= max_diff_n1_d1;

% Balance constraint: difference between Nurse2 and Doctor2 hours must not exceed max_diff_n2_d2
constraint abs(hours_nurse2 - hours_doctor2) <= max_diff_n2_d2;


% Objective
solve minimize total_workload_score;