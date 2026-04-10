% Sports training center scheduling (integer hours) - minimize total fatigue

var 0..5: X;  % hours for group X
var 0..5: Y;  % hours for group Y
var 0..6: Z;  % hours for group Z
var 0..6: W;  % hours for group W

% Facility/trainer availability constraints
constraint X + Y <= 10;
constraint Z + W <= 12;

% Balanced program constraints
constraint X + Z >= 6;
constraint Y + W >= 8;

% Total fatigue score
var int: fatigue = 2*X + 3*Y + 4*Z + 5*W;

solve minimize fatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "Minimum total fatigue (rounded) = ", show(fatigue), "\n"
];