% Parameters (with values embedded)
int: nLabs = 2;
set of int: Labs = 1..nLabs;

int: heart_req = 20000;
int: lung_req  = 30000;

array[Labs] of int: heart_rate = [20, 30];  % pills per hour at each lab
array[Labs] of int: lung_rate  = [30, 40];  % pills per hour at each lab

array[Labs] of int: labor_per_hour = [3, 5]; % worker-hours required per lab-hour
int: labor_available = 1500;

% Variables
array[Labs] of var 0..100000: hours; % hours to run each lab (bounded large enough)
var 0..200000: total_hours = sum(l in Labs)(hours[l]);

% Constraints
constraint sum(l in Labs)(labor_per_hour[l] * hours[l]) <= labor_available;

constraint sum(l in Labs)(heart_rate[l] * hours[l]) >= heart_req;
constraint sum(l in Labs)(lung_rate[l] * hours[l]) >= lung_req;

% Objective
solve minimize total_hours;