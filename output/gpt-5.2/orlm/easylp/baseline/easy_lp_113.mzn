int: max_total_drills = 40;
int: min_skill_requirement = 30;

int: fatigue_X = 2;
int: fatigue_Y = 3;

var 0..max_total_drills: X;
var 0..max_total_drills: Y;

constraint X + Y <= max_total_drills;
constraint 2 * X + Y >= min_skill_requirement;

var int: total_fatigue = fatigue_X * X + fatigue_Y * Y;

solve minimize total_fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total fatigue = ", show(total_fatigue), "\n"
];