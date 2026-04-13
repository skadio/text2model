% Hospital staffing optimization (embed all data here)

% Data (from problem statement)
int: tech_hours = 8;      % ultrasound technician hours per shift
int: grad_hours = 5;      % graduate researcher hours per shift
int: tech_cost  = 300;    % $ per technician shift
int: grad_cost  = 100;    % $ per graduate shift
int: required_hours = 500;
int: budget = 14000;

% Decision variables: number of shifts scheduled for each type
var 0..ceil(required_hours / min(tech_hours, grad_hours)): tech_shifts;
var 0..ceil(required_hours / min(tech_hours, grad_hours)): grad_shifts;

% Regulations: twice as many technician shifts as graduate shifts
constraint tech_shifts = 2 * grad_shifts;

% Meet required ultrasound service hours (total coverage)
constraint tech_hours * tech_shifts + grad_hours * grad_shifts >= required_hours;

% Budget constraint
constraint tech_cost * tech_shifts + grad_cost * grad_shifts <= budget;

% Objective: reduce total number of workers (shifts) scheduled
var 0..1000: total_shifts = tech_shifts + grad_shifts;
solve minimize total_shifts;

output [
  "tech_shifts = ", show(tech_shifts), "\n",
  "grad_shifts = ", show(grad_shifts), "\n",
  "total_shifts = ", show(total_shifts), "\n",
  "total_hours = ", show(tech_hours * tech_shifts + grad_hours * grad_shifts), "\n",
  "total_cost = $", show(tech_cost * tech_shifts + grad_cost * grad_shifts), "\n"
];