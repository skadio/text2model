% Budget allocation (all data embedded)

% Cost coefficients (resource units per dollar)
float: c_teacher = 0.3;
float: c_rent    = 0.2;
float: c_textbook= 0.4;
float: c_misc    = 0.1;

% Bounds (in dollars)
int: teacher_min  = 50000;
int: teacher_max  = 80000;

int: rent_min     = 10000;
int: rent_max     = 20000;

int: textbook_min = 5000;
int: textbook_max = 10000;

int: misc_min     = 5000;
int: misc_max     = 7000;

% Total budget is not given explicitly; infer the only feasible value
% from the requirement that allocations sum to Budget.
int: Budget = teacher_min + rent_min + textbook_min + misc_min; % = 70000

% Decision variables (integer dollars)
var teacher_min..teacher_max: TeacherSalary;
var rent_min..rent_max: ClassroomRent;
var textbook_min..textbook_max: TextbookCosts;
var misc_min..misc_max: MiscExpenses;

% Scale objective by 10 to avoid floating-point arithmetic:
% 10 * total_resource = 3*T + 2*R + 4*B + 1*M
var 0..(3*teacher_max + 2*rent_max + 4*textbook_max + misc_max): total_resource_x10;

constraint TeacherSalary + ClassroomRent + TextbookCosts + MiscExpenses = Budget;

constraint total_resource_x10 =
  3*TeacherSalary + 2*ClassroomRent + 4*TextbookCosts + MiscExpenses;

solve minimize total_resource_x10;

% Output minimum total resource consumption rounded to two decimals
output [
  "TeacherSalary=", show(TeacherSalary), "\n",
  "ClassroomRent=", show(ClassroomRent), "\n",
  "TextbookCosts=", show(TextbookCosts), "\n",
  "MiscExpenses=", show(MiscExpenses), "\n",
  "MinTotalResourceUnits=",
  show((total_resource_x10 div 10)), ".", show(total_resource_x10 mod 10), "0", "\n"
];