% Sports training allocation - minimize fatigue

var 0..15: X;  % hours for exercise X
var 0..20: Y;  % hours for exercise Y
var 0..25: Z;  % hours for exercise Z

constraint X + Y + Z >= 10;
constraint abs(X - Y) <= 4;
constraint abs(Y - Z) <= 5;

var int: fatigue = 2*X + 3*Y + 1*Z;

solve minimize fatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_fatigue=", show(fatigue), "\n",
  "rounded_minimum_total_fatigue=", show(fatigue), "\n"
];