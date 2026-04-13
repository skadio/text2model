% Training hours allocation to minimize total fatigue

var int: X; % strength conditioning hours
var int: Y; % skill development hours
var int: Z; % strategy & tactics hours

constraint X >= 200;
constraint Y >= 150;
constraint Z >= 250;
constraint X + Y + Z <= 1000;

var int: total_fatigue = 2*X + 3*Y + 4*Z;

solve minimize total_fatigue;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_fatigue=", show(total_fatigue), "\n",
  "minimum_total_fatigue_rounded=", show(total_fatigue), "\n"
];