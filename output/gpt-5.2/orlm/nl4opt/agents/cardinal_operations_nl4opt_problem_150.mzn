% Parameters
% Production rates (pills per hour) at each lab
int: heart_rate_lab1 = 20;
int: lung_rate_lab1  = 30;
int: heart_rate_lab2 = 30;
int: lung_rate_lab2  = 40;

% Worker labor required per hour of running each lab (worker-hours per lab-hour)
int: labor_per_hour_lab1 = 3;
int: labor_per_hour_lab2 = 5;

% Available worker-hours
int: labor_available = 1500;

% Minimum production requirements (pills)
int: min_heart = 20000;
int: min_lung  = 30000;

% Upper bounds on lab running time from labor availability (for bounded variables)
int: max_hours_lab1 = labor_available div labor_per_hour_lab1; % 1500/3 = 500
int: max_hours_lab2 = labor_available div labor_per_hour_lab2; % 1500/5 = 300


% Variables
% Hours to run each lab (non-negative integers, bounded by labor-based maxima)
var 0..max_hours_lab1: hours_lab1;
var 0..max_hours_lab2: hours_lab2;

% Total time to minimize (hours)
var 0..(max_hours_lab1 + max_hours_lab2): total_hours;


% Constraints
% Link total time variable to the sum of lab running hours
constraint total_hours = hours_lab1 + hours_lab2;

% Meet minimum heart medication production requirement
constraint
  heart_rate_lab1 * hours_lab1 + heart_rate_lab2 * hours_lab2 >= min_heart;

% Meet minimum lung medication production requirement
constraint
  lung_rate_lab1 * hours_lab1 + lung_rate_lab2 * hours_lab2 >= min_lung;

% Do not exceed available worker labor hours
constraint
  labor_per_hour_lab1 * hours_lab1 + labor_per_hour_lab2 * hours_lab2 <= labor_available;


% Objective
solve minimize total_hours;