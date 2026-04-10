% HR staff allocation: minimize total cost with integer staffing

var 0..100: X;
var 0..100: Y;
var 0..100: Z;

constraint X + Y + Z <= 100;

% "X should be at least twice the half of Y" => X >= Y
constraint X >= Y;

% "Z should not exceed by more than 10 the three-fourths of X"
% Z <= (3/4)X + 10  <=> 4Z <= 3X + 40
constraint 4 * Z <= 3 * X + 40;

% Cost (in dollars)
var int: total_cost = 5000 * X + 4000 * Y + 6000 * Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=$", show(total_cost), "\n"
];