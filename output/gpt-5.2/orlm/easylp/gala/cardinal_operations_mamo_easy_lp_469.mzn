% Training allocation optimization (all data embedded)

% Parameters
int: totalHoursMax = 10;
int: effMin = 30;
int: diffMax = 2;

int: xMax = 6;
int: yMax = 8;

int: effX = 3;
int: effY = 4;

int: fatX = 40;
int: fatY = 60;

% Decision variables (hours on each exercise)
var 0..xMax: X;
var 0..yMax: Y;

% Constraints
constraint X + Y <= totalHoursMax;
constraint effX * X + effY * Y >= effMin;
constraint abs(X - Y) <= diffMax;

% Objective: minimize total fatigue
var 0..(fatX*xMax + fatY*yMax): fatigue = fatX * X + fatY * Y;

solve minimize fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total fatigue (rounded) = ", show(fatigue), "\n"
];