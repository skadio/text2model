% Budget allocation model (all data embedded)

% Resource consumption coefficients
float: c_teacher = 0.3;
float: c_rent    = 0.2;
float: c_text    = 0.4;
float: c_misc    = 0.1;

% Bounds (in whole dollars)
int: teacher_min = 50000;
int: teacher_max = 80000;

int: rent_min = 10000;
int: rent_max = 20000;

int: text_min = 5000;
int: text_max = 10000;

int: misc_min = 5000;
int: misc_max = 7000;

% Total budget (must be specified; choose a valid budget within feasible range)
% Feasible Budget range: [teacher_min+rent_min+text_min+misc_min .. teacher_max+rent_max+text_max+misc_max]
int: Budget = 70000;

% Decision variables
var teacher_min..teacher_max: TeacherSalary;
var rent_min..rent_max: ClassroomRent;
var text_min..text_max: TextbookCosts;
var misc_min..misc_max: MiscExpenses;

% Integer-scaled objective (x10) to avoid floating arithmetic in the solve statement
var 0..(3*teacher_max + 2*rent_max + 4*text_max + 1*misc_max): total_cost_x10;

% Constraints
constraint TeacherSalary + ClassroomRent + TextbookCosts + MiscExpenses = Budget;

constraint total_cost_x10 =
    3 * TeacherSalary + 2 * ClassroomRent + 4 * TextbookCosts + 1 * MiscExpenses;

% Objective: minimize total resource consumption
solve minimize total_cost_x10;

output [
  "Budget=", show(Budget), "\n",
  "TeacherSalary=", show(TeacherSalary), "\n",
  "ClassroomRent=", show(ClassroomRent), "\n",
  "TextbookCosts=", show(TextbookCosts), "\n",
  "MiscExpenses=", show(MiscExpenses), "\n",
  "MinTotalCost=", show(total_cost_x10 / 10.0), "\n",
  "MinTotalCostRounded2=", show(round(100.0 * (total_cost_x10 / 10.0)) / 100.0), "\n"
];