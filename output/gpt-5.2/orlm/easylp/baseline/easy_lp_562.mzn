% School district funding allocation: minimize total cost subject to constraints.
% Variables are integer dollars.

var 0..600: X;
var 0..400: Y;
var 0..300: Z;

constraint X + Y + Z <= 1000;
constraint 2 * X + Y >= 400;
constraint Y + Z >= 500;

% Benefit per dollar (not used in constraints/objective as description asks to minimize cost)
int: benefitX = 5;
int: benefitY = 3;
int: benefitZ = 1;

var int: total_cost = X + Y + Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];