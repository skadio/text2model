int: budget = 0;

float: c_teacher = 0.3;
float: c_rent = 0.2;
float: c_textbooks = 0.4;
float: c_misc = 0.1;

int: teacher_min = 50000;
int: teacher_max = 80000;

int: rent_min = 10000;
int: rent_max = 20000;

int: textbooks_min = 5000;
int: textbooks_max = 10000;

int: misc_min = 5000;
int: misc_max = 7000;

var teacher_min..teacher_max: teacher;
var rent_min..rent_max: rent;
var textbooks_min..textbooks_max: textbooks;
var misc_min..misc_max: misc;

var float: total_cost;

constraint teacher + rent + textbooks + misc = budget;

constraint total_cost =
  c_teacher * int2float(teacher) +
  c_rent * int2float(rent) +
  c_textbooks * int2float(textbooks) +
  c_misc * int2float(misc);

solve minimize total_cost;

output [
  "teacher=", show(teacher), "\n",
  "rent=", show(rent), "\n",
  "textbooks=", show(textbooks), "\n",
  "misc=", show(misc), "\n",
  "budget=", show(budget), "\n",
  "total_cost=", show(total_cost), "\n"
];