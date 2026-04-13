int: hours_needed = 300;
int: budget = 7000;

int: reg_hours = 10;
int: reg_cost = 300;

int: eme_hours = 6;
int: eme_cost = 100;

var 0..ceil(hours_needed div reg_hours) + ceil(hours_needed div eme_hours): reg;
var 0..ceil(hours_needed div eme_hours) + ceil(hours_needed div reg_hours): eme;

constraint reg * reg_hours + eme * eme_hours >= hours_needed;
constraint reg * reg_cost + eme * eme_cost <= budget;

solve minimize reg + eme;

output [
  "regular_firefighters = ", show(reg), "\n",
  "emergency_firefighters = ", show(eme), "\n",
  "total_firefighters = ", show(reg + eme), "\n",
  "total_hours = ", show(reg * reg_hours + eme * eme_hours), "\n",
  "total_cost = ", show(reg * reg_cost + eme * eme_cost), "\n"
];