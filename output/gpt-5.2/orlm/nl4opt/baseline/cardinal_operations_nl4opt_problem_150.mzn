% Pharmaceutical production scheduling (embedded data)

int: H_req = 20000;
int: L_req = 30000;
int: worker_hours_avail = 1500;

int: H_rate_lab1 = 20; % heart pills per hour at lab 1
int: L_rate_lab1 = 30; % lung pills per hour at lab 1
int: H_rate_lab2 = 30; % heart pills per hour at lab 2
int: L_rate_lab2 = 40; % lung pills per hour at lab 2

int: labor_per_hour_lab1 = 3; % worker hours per hour of running lab 1
int: labor_per_hour_lab2 = 5; % worker hours per hour of running lab 2

% Decision variables: hours to run each lab (continuous via scaling)
int: SCALE = 10; % tenths of an hour
var 0..1000000: x1u; % lab 1 hours * SCALE
var 0..1000000: x2u; % lab 2 hours * SCALE

constraint
  H_rate_lab1 * x1u + H_rate_lab2 * x2u >= H_req * SCALE;
constraint
  L_rate_lab1 * x1u + L_rate_lab2 * x2u >= L_req * SCALE;

% Worker-hours constraint: (3*x1 + 5*x2) <= 1500
% Multiply by SCALE to avoid fractions.
constraint
  labor_per_hour_lab1 * x1u + labor_per_hour_lab2 * x2u <= worker_hours_avail * SCALE;

% Minimize total running time x1 + x2
var int: total_time_u = x1u + x2u;

solve minimize total_time_u;

output [
  "Lab1 hours = ", show(x1u div SCALE), ".", show((x1u mod SCALE) * (10 div SCALE)), "\n",
  "Lab2 hours = ", show(x2u div SCALE), ".", show((x2u mod SCALE) * (10 div SCALE)), "\n",
  "Total hours = ", show(total_time_u div SCALE), ".", show((total_time_u mod SCALE) * (10 div SCALE)), "\n",
  "Worker hours used = ", show((labor_per_hour_lab1 * x1u + labor_per_hour_lab2 * x2u) div SCALE),
    ".", show(((labor_per_hour_lab1 * x1u + labor_per_hour_lab2 * x2u) mod SCALE) * (10 div SCALE)), "\n",
  "Heart pills = ", show((H_rate_lab1 * x1u + H_rate_lab2 * x2u) div SCALE),
    ".", show(((H_rate_lab1 * x1u + H_rate_lab2 * x2u) mod SCALE) * (10 div SCALE)), "\n",
  "Lung pills  = ", show((L_rate_lab1 * x1u + L_rate_lab2 * x2u) div SCALE),
    ".", show(((L_rate_lab1 * x1u + L_rate_lab2 * x2u) mod SCALE) * (10 div SCALE)), "\n"
];