% Parameters
int: heart_rate_lab1 = 20;      % pills/hour
int: lung_rate_lab1  = 30;      % pills/hour
int: heart_rate_lab2 = 30;      % pills/hour
int: lung_rate_lab2  = 40;      % pills/hour

int: labor_per_hour_lab1 = 3;   % worker-hours per lab-hour
int: labor_per_hour_lab2 = 5;   % worker-hours per lab-hour
int: labor_available = 1500;    % worker-hours available

int: heart_demand = 20000;      % pills
int: lung_demand  = 30000;      % pills

% Variables
var 0..labor_available: h1;     % hours run at lab 1
var 0..labor_available: h2;     % hours run at lab 2
var 0..2*labor_available: total_time;

% Constraints
constraint total_time = h1 + h2;

constraint heart_rate_lab1 * h1 + heart_rate_lab2 * h2 >= heart_demand;
constraint lung_rate_lab1  * h1 + lung_rate_lab2  * h2 >= lung_demand;

constraint labor_per_hour_lab1 * h1 + labor_per_hour_lab2 * h2 <= labor_available;

% Objective
solve minimize total_time;