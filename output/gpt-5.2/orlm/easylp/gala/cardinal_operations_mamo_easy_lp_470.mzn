% Training allocation optimization (all data embedded)

% Decision variables: whole hours
var 0..10: X;  % strength conditioning hours
var 0..10: Y;  % skill development hours

% Constraints
constraint X + Y <= 10;
constraint X >= Y + 1;
constraint 2*X + Y = 15;

% Fatigue points per hour
int: fatigueX = 2;
int: fatigueY = 3;

var 0..100: total_fatigue = fatigueX * X + fatigueY * Y;

solve minimize total_fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total fatigue (rounded) = ", show(total_fatigue), "\n"
];