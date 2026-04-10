% Parameters
int: heart_rate_lab1 = 20;          % heart pills produced per hour at lab 1
int: lung_rate_lab1  = 30;          % lung pills produced per hour at lab 1
int: heart_rate_lab2 = 30;          % heart pills produced per hour at lab 2
int: lung_rate_lab2  = 40;          % lung pills produced per hour at lab 2

int: labor_per_session_lab1 = 3;    % worker labor hours required per hour at lab 1
int: labor_per_session_lab2 = 5;    % worker labor hours required per hour at lab 2
int: total_labor_available  = 1500; % total worker hours available

int: min_heart_pills = 20000;       % minimum required heart pills
int: min_lung_pills  = 30000;       % minimum required lung pills


% Variables
var 0..total_labor_available: hours_lab1; % hours to run lab 1
var 0..total_labor_available: hours_lab2; % hours to run lab 2

var 0..(heart_rate_lab1*total_labor_available + heart_rate_lab2*total_labor_available): total_heart_pills;
var 0..(lung_rate_lab1*total_labor_available + lung_rate_lab2*total_labor_available): total_lung_pills;

var 0..(2*total_labor_available): total_time; % total operating hours across both labs


% Constraints
% Link production variables to chosen lab hours
constraint
  total_heart_pills =
    heart_rate_lab1 * hours_lab1 + heart_rate_lab2 * hours_lab2;

constraint
  total_lung_pills =
    lung_rate_lab1 * hours_lab1 + lung_rate_lab2 * hours_lab2;

% Labor availability constraint (worker-hours consumed by running labs)
constraint
  labor_per_session_lab1 * hours_lab1 + labor_per_session_lab2 * hours_lab2
  <= total_labor_available;

% Minimum demand constraints for medications
constraint total_heart_pills >= min_heart_pills;
constraint total_lung_pills  >= min_lung_pills;

% Define total time as the sum of operating hours across both labs
constraint total_time = hours_lab1 + hours_lab2;


% Objective
solve minimize total_time;