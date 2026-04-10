int: max_matches = 50;
int: min_competitiveness = 30;
int: max_imbalance = 10;

int: fatigue_X = 4;
int: fatigue_Y = 3;

var 0..max_matches: x; % matches of sport X
var 0..max_matches: y; % matches of sport Y

constraint x + y <= max_matches;
constraint 2*x + y >= min_competitiveness;
constraint x - 2*y <= max_imbalance;

var int: total_fatigue = fatigue_X * x + fatigue_Y * y;

solve minimize total_fatigue;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_fatigue=", show(total_fatigue), "\n",
  "rounded_total_fatigue=", show(total_fatigue), "\n"
];