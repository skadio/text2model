% Parameters (with values embedded)
int: Budget = 100000;

float: c_teacher = 0.3;
float: c_rent    = 0.2;
float: c_text    = 0.4;
float: c_misc    = 0.1;

int: teacher_min = 50000;
int: teacher_max = 80000;

int: rent_min = 10000;
int: rent_max = 20000;

int: text_min = 5000;
int: text_max = 10000;

int: misc_min = 5000;
int: misc_max = 7000;

% Variables
var teacher_min..teacher_max: TeacherSalary;
var rent_min..rent_max: ClassroomRent;
var text_min..text_max: TextbookCosts;
var misc_min..misc_max: MiscExpenses;

% Use scaled integer objective to avoid floating-point issues:
% total_resource_units = 0.3*T + 0.2*R + 0.4*X + 0.1*M
% Multiply by 10 => 3*T + 2*R + 4*X + 1*M
var 0..(4*teacher_max + 4*rent_max + 4*text_max + 4*misc_max): total_cost_scaled10;

% Constraints
constraint TeacherSalary + ClassroomRent + TextbookCosts + MiscExpenses = Budget;

constraint total_cost_scaled10 =
  3*TeacherSalary + 2*ClassroomRent + 4*TextbookCosts + 1*MiscExpenses;

% Objective
solve minimize total_cost_scaled10;

output [
  "TeacherSalary = $", show(TeacherSalary), "\n",
  "ClassroomRent = $", show(ClassroomRent), "\n",
  "TextbookCosts = $", show(TextbookCosts), "\n",
  "MiscExpenses  = $", show(MiscExpenses), "\n",
  "Minimum total cost (resource units) = ", show(total_cost_scaled10 div 10), ".", show(total_cost_scaled10 mod 10), "0\n"
];