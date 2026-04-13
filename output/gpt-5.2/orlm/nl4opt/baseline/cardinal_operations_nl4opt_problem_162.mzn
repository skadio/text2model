% Hospital staffing: minimize total workers (shifts) subject to hours, budget, and ratio rules.

int: tech_hours_per_shift = 8;
int: grad_hours_per_shift = 5;

int: tech_cost_per_shift = 300;
int: grad_cost_per_shift = 100;

int: required_hours = 500;
int: budget = 14000;

% Decision variables: number of shifts to schedule
var 0..10000: tech_shifts;
var 0..10000: grad_shifts;

% Regulations: twice as many technician shifts as graduate researcher shifts
constraint tech_shifts = 2 * grad_shifts;

% Meet required ultrasound service hours
constraint tech_hours_per_shift * tech_shifts + grad_hours_per_shift * grad_shifts >= required_hours;

% Stay within budget
constraint tech_cost_per_shift * tech_shifts + grad_cost_per_shift * grad_shifts <= budget;

% Objective: reduce total number of workers/shifts scheduled
solve minimize tech_shifts + grad_shifts;

output [
  "technician_shifts = ", show(tech_shifts), "\n",
  "graduate_shifts = ", show(grad_shifts), "\n",
  "total_shifts = ", show(tech_shifts + grad_shifts), "\n",
  "total_hours = ", show(tech_hours_per_shift * tech_shifts + grad_hours_per_shift * grad_shifts), "\n",
  "total_cost = $", show(tech_cost_per_shift * tech_shifts + grad_cost_per_shift * grad_shifts), "\n"
];