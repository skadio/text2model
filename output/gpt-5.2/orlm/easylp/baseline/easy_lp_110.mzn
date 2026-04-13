% Training hours allocation (integer hours)
var 0..100: X; % group X stamina hours
var 0..100: Y; % group Y skill hours

% Constraints
constraint X + Y <= 100;
constraint X >= Y + 10;
constraint 2 * X + Y >= 60;

% Objective: minimize total fatigue score
var 0..1000: fatigue = 2 * X + 3 * Y;
solve minimize fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total fatigue score = ", show(fatigue), "\n"
];