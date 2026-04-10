int: hours_required = 1000;
int: budget = 40000;

int: staff_hours = 6;
int: staff_cost = 300;

int: sub_hours = 3;
int: sub_cost = 100;

var 0..100000: staff;
var 0..100000: subs;

constraint staff_hours * staff + sub_hours * subs >= hours_required;
constraint staff_cost * staff + sub_cost * subs <= budget;

solve minimize staff + subs;

output [
  "staff=", show(staff), "\n",
  "subs=", show(subs), "\n",
  "total_teachers=", show(staff + subs), "\n",
  "total_hours=", show(staff_hours * staff + sub_hours * subs), "\n",
  "total_cost=", show(staff_cost * staff + sub_cost * subs), "\n"
];