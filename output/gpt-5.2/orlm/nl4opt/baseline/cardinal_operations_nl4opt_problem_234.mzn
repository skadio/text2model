int: hours_part = 15;
int: pay_part = 450;

int: hours_full = 40;
int: pay_full = 1280;

int: required_hours = 1000;
int: budget = 31500;

% Upper bounds (safe)
int: max_full = required_hours div hours_full + 100;   % slack
int: max_part = required_hours div hours_part + 100;   % slack

var 0..max_part: part_time;
var 0..max_full: full_time;

constraint hours_part * part_time + hours_full * full_time >= required_hours;
constraint pay_part * part_time + pay_full * full_time <= budget;

var int: total_staff = part_time + full_time;

solve minimize total_staff;

output [
  "part_time = ", show(part_time), "\n",
  "full_time = ", show(full_time), "\n",
  "total_staff = ", show(total_staff), "\n",
  "total_hours = ", show(hours_part * part_time + hours_full * full_time), "\n",
  "total_pay = ", show(pay_part * part_time + pay_full * full_time), "\n"
];