% Parameters
int: heart_rate_lab1 = 20;        % pills/hour
int: lung_rate_lab1  = 30;        % pills/hour
int: heart_rate_lab2 = 30;        % pills/hour
int: lung_rate_lab2  = 40;        % pills/hour

int: labor_per_hour_lab1 = 3;     % worker-hours per lab-hour
int: labor_per_hour_lab2 = 5;     % worker-hours per lab-hour
int: labor_available = 1500;      % worker-hours

int: min_heart = 20000;           % pills
int: min_lung  = 30000;           % pills

% Variables
var 0..1500: h1;                  % hours to run lab 1
var 0..1500: h2;                  % hours to run lab 2

% Constraints
constraint
  labor_per_hour_lab1 * h1 + labor_per_hour_lab2 * h2 <= labor_available;

constraint
  heart_rate_lab1 * h1 + heart_rate_lab2 * h2 >= min_heart;

constraint
  lung_rate_lab1 * h1 + lung_rate_lab2 * h2 >= min_lung;

% Objective
solve minimize h1 + h2;