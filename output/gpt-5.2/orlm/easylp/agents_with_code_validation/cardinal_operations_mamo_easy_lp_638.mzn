% School budget allocation (ILP)

% Resource-consumption coefficients per dollar (use exact scaled integers)
int: scale = 10;
int: c_teacher = 3; % 0.3 * 10
int: c_rent    = 2; % 0.2 * 10
int: c_text    = 4; % 0.4 * 10
int: c_misc    = 1; % 0.1 * 10

% Dollar bounds (inclusive)
int: teacher_min = 50000;
int: teacher_max = 80000;

int: rent_min = 10000;
int: rent_max = 20000;

int: text_min = 5000;
int: text_max = 10000;

int: misc_min = 5000;
int: misc_max = 7000;

% Total available budget (not provided in the description).
% Set to the minimum feasible total to make the model solvable; change if needed.
int: Budget = teacher_min + rent_min + text_min + misc_min;

% Decision variables (whole dollars)
var teacher_min..teacher_max: teacher_salary;
var rent_min..rent_max:       classroom_rent;
var text_min..text_max:       textbook_costs;
var misc_min..misc_max:       miscellaneous_expenses;

% Scaled integer total resource consumption (scale * total_cost)
var 0..(c_teacher*teacher_max + c_rent*rent_max + c_text*text_max + c_misc*misc_max): total_cost_scaled;

% Constraints
constraint teacher_salary + classroom_rent + textbook_costs + miscellaneous_expenses = Budget;

constraint total_cost_scaled =
    c_teacher * teacher_salary
  + c_rent    * classroom_rent
  + c_text    * textbook_costs
  + c_misc    * miscellaneous_expenses;

% Objective
solve minimize total_cost_scaled;

% Reporting (rounded to 2 decimals)
output [
  "teacher_salary = ", show(teacher_salary), "\n",
  "classroom_rent = ", show(classroom_rent), "\n",
  "textbook_costs = ", show(textbook_costs), "\n",
  "miscellaneous_expenses = ", show(miscellaneous_expenses), "\n",
  "total_cost = ", show_float(2, int2float(total_cost_scaled) / int2float(scale)), "\n"
];