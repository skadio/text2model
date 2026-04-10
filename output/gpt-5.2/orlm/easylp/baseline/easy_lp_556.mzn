% Resource allocation for training areas with integer efforts

var 0..100: x1; % strength conditioning
var 0..100: x2; % skill development
var 0..100: x3; % strategy and tactics

% Constraints
constraint x1 + x2 <= 10;
constraint 4*x1 + 5*x3 >= 20;
constraint x3 - x2 <= 5;
constraint 2*x3 >= x1; % x3 >= x1/2 (avoid fractions)

% Objective: minimize total fatigue score
var int: fatigue = 2*x1 + 3*x2 + 5*x3;
solve minimize fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "minimum_total_fatigue_rounded=", show(fatigue), "\n"
];