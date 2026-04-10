% Accounting firm staffing problem
% Minimize total number of workers (shifts) subject to labor-hour and budget limits.

int: required_hours = 500;
int: budget = 15000;

int: hours_full = 8;
int: hours_part = 4;

int: cost_full = 300;
int: cost_part = 100;

% Decision variables: number of full-time and part-time workers (scheduled shifts)
var 0..(required_hours div hours_full + 1000): full_workers;
var 0..(required_hours div hours_part + 1000): part_workers;

constraint hours_full * full_workers + hours_part * part_workers >= required_hours;
constraint cost_full * full_workers + cost_part * part_workers <= budget;

solve minimize full_workers + part_workers;

output [
  "full_workers = ", show(full_workers), "\n",
  "part_workers = ", show(part_workers), "\n",
  "total_workers = ", show(full_workers + part_workers), "\n",
  "total_hours = ", show(hours_full * full_workers + hours_part * part_workers), "\n",
  "total_cost = $", show(cost_full * full_workers + cost_part * part_workers), "\n"
];