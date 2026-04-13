% Parameters
int: heart_rate_lab1 = 20;     % heart pills per hour at lab 1
int: lung_rate_lab1  = 30;     % lung pills per hour at lab 1
int: heart_rate_lab2 = 30;     % heart pills per hour at lab 2
int: lung_rate_lab2  = 40;     % lung pills per hour at lab 2

int: labor_per_hour_lab1 = 3;  % worker-hours per hour run at lab 1
int: labor_per_hour_lab2 = 5;  % worker-hours per hour run at lab 2
int: labor_available = 1500;

int: heart_min = 20000;
int: lung_min  = 30000;

% Variables
var 0..labor_available: h1; % hours run at lab 1
var 0..labor_available: h2; % hours run at lab 2

% Constraints
constraint labor_per_hour_lab1 * h1 + labor_per_hour_lab2 * h2 <= labor_available;

constraint heart_rate_lab1 * h1 + heart_rate_lab2 * h2 >= heart_min;
constraint lung_rate_lab1  * h1 + lung_rate_lab2  * h2 >= lung_min;

% Objective
solve minimize h1 + h2;