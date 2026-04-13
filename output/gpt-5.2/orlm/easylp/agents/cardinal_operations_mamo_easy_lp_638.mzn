% Parameters
% Resource consumption coefficients (units per dollar)
float: coeff_teacher = 0.3;
float: coeff_rent    = 0.2;
float: coeff_text    = 0.4;
float: coeff_misc    = 0.1;

% Budget (total dollars available)
% NOTE: No numeric value provided in the statement, so it remains a parameter.
int: Budget;

% Dollar bounds for each category (inclusive)
int: teacher_min = 50000;
int: teacher_max = 80000;

int: rent_min = 10000;
int: rent_max = 20000;

int: text_min = 5000;
int: text_max = 10000;

int: misc_min = 5000;
int: misc_max = 7000;


% Variables
% Dollar allocations (whole dollars)
var teacher_min..teacher_max: TeacherSalary;
var rent_min..rent_max: ClassroomRent;
var text_min..text_max: TextbookCosts;
var misc_min..misc_max: MiscExpenses;

% Total resource consumption units scaled by 100 (to avoid float arithmetic in the objective)
% This equals: 100 * (0.3*TeacherSalary + 0.2*ClassroomRent + 0.4*TextbookCosts + 0.1*MiscExpenses)
var int: TotalCost_x100;


% Constraints
%---------------------------
% Budget feasibility / balance
%---------------------------
constraint
  TeacherSalary + ClassroomRent + TextbookCosts + MiscExpenses = Budget;

%---------------------------
% Cost accounting (scaled by 100)
%---------------------------
% Coefficients have one decimal place, so multiplying by 100 yields exact integers:
% 0.3*100=30, 0.2*100=20, 0.4*100=40, 0.1*100=10
constraint
  TotalCost_x100 =
    30 * TeacherSalary +
    20 * ClassroomRent +
    40 * TextbookCosts +
    10 * MiscExpenses;


% Objective
solve minimize TotalCost_x100;