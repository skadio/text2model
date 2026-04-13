% Budget Allocation ILP - all data embedded

int: Budget = 90000;

% Resource consumption per dollar (scaled by 1000 to keep integer objective)
% 0.3 -> 300, 0.2 -> 200, 0.4 -> 400, 0.1 -> 100
int: c_teacher = 300;
int: c_rent   = 200;
int: c_text   = 400;
int: c_misc   = 100;

var 50000..80000: teacher;
var 10000..20000: rent;
var 5000..10000: text;
var 5000..7000: misc;

constraint teacher + rent + text + misc = Budget;

var int: objScaled = c_teacher*teacher + c_rent*rent + c_text*text + c_misc*misc;

solve minimize objScaled;

% Convert back to real resource units: (objScaled / 1000.0)
% and print rounded to 2 decimals.
output [
  "TeacherSalary = $", show(teacher), "\n",
  "ClassroomRent = $", show(rent), "\n",
  "TextbookCosts = $", show(text), "\n",
  "Miscellaneous = $", show(misc), "\n",
  "Budget = $", show(Budget), "\n",
  "MinResourceConsumptionUnits = ",
  show( round( (objScaled / 1000.0) * 100.0 ) / 100.0 ),
  "\n"
];