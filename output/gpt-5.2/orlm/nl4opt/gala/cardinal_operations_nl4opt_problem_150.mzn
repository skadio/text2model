% Pharmaceutical labs production planning (minimize total run time)

include "globals.mzn";

% ----- Data (embedded from description) -----
int: heart_need = 20000;
int: lung_need  = 30000;
int: worker_hours_avail = 1500;

int: heart_rate_lab1 = 20;   % pills per hour
int: lung_rate_lab1  = 30;

int: heart_rate_lab2 = 30;
int: lung_rate_lab2  = 40;

int: labor_per_hour_lab1 = 3;  % worker-hours per lab-hour
int: labor_per_hour_lab2 = 5;

% Upper bounds from worker-hours to keep domains finite
int: max_h1 = worker_hours_avail div labor_per_hour_lab1; % 500
int: max_h2 = worker_hours_avail div labor_per_hour_lab2; % 300

% ----- Decision variables -----
var 0..max_h1: h1;  % hours to run lab 1
var 0..max_h2: h2;  % hours to run lab 2

% ----- Constraints -----
constraint labor_per_hour_lab1 * h1 + labor_per_hour_lab2 * h2 <= worker_hours_avail;

constraint heart_rate_lab1 * h1 + heart_rate_lab2 * h2 >= heart_need;
constraint lung_rate_lab1  * h1 + lung_rate_lab2  * h2 >= lung_need;

% ----- Objective: minimize total lab run time -----
var 0..(max_h1 + max_h2): total_time = h1 + h2;

solve minimize total_time;

% ----- Output -----
output [
  "Lab1_hours = ", show(h1), "\n",
  "Lab2_hours = ", show(h2), "\n",
  "Total_time = ", show(total_time), "\n",
  "Worker_hours_used = ", show(labor_per_hour_lab1*h1 + labor_per_hour_lab2*h2), "\n",
  "Heart_pills = ", show(heart_rate_lab1*h1 + heart_rate_lab2*h2), "\n",
  "Lung_pills = ", show(lung_rate_lab1*h1 + lung_rate_lab2*h2), "\n"
];