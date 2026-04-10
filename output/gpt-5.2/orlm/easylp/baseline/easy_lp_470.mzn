% Training hours allocation problem (embedded data)

int: max_total_hours = 10;
int: extra_strength_hours = 1;
int: eq_rhs = 15;

int: fatigue_X = 2; % fatigue points per hour of strength conditioning
int: fatigue_Y = 3; % fatigue points per hour of skill development

var 0..max_total_hours: X; % hours of strength conditioning
var 0..max_total_hours: Y; % hours of skill development

constraint X + Y <= max_total_hours;
constraint X >= Y + extra_strength_hours;
constraint 2*X + Y = eq_rhs;

var int: total_fatigue = fatigue_X * X + fatigue_Y * Y;

solve minimize total_fatigue;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_fatigue=", show(total_fatigue), "\n",
  "min_total_fatigue_rounded=", show(total_fatigue), "\n"
];