% Sports tournament scheduling (all data embedded)

% Decision variables: number of matches in sports X and Y (integers)
var 0..50: x;  % matches for sport X
var 0..50: y;  % matches for sport Y

% Constraints
constraint x + y <= 50;
constraint 2*x + y >= 30;
constraint abs(x - 2*y) <= 10;

% Objective: minimize total fatigue score
var 0..1000: fatigue = 4*x + 3*y;
solve minimize fatigue;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_fatigue = ", show(fatigue), "\n"
];