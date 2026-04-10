% Environmental agency fund allocation (all data embedded)

var 0..50: X;              % Project X max 50
var 0..40: Y;              % Project Y max 40
var 0..1000: Z;            % Project Z no stated upper bound; safe large cap

constraint X + Y + Z <= 100;
constraint 2*X - Y >= 20;
constraint Y + Z <= 70;

var int: TotalCost = 2*X + 3*Y + 4*Z;

solve minimize TotalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(TotalCost), "\n"
];