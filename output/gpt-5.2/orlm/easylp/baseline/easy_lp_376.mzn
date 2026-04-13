int: maxXplusY = 50;
int: minX = 20;
int: maxY = 30;

% Costs per employee
float: cX = 1.5;
float: cY = 2.0;
float: cZ = 3.0;
float: cW = 4.0;

% Decision variables: integer employees in each department
var 0..100: X;
var 0..100: Y;
var 0..100: Z;
var 0..100: W;

constraint X + Y <= maxXplusY;
constraint X >= minX;
constraint Y <= maxY;
constraint Z + W - X <= 0;  % X >= Z + W

% Total cost (in cost units)
var float: total_cost = cX*X + cY*Y + cZ*Z + cW*W;

solve minimize total_cost;

% Rounded to nearest whole number (half up)
var int: rounded_cost = floor(total_cost + 0.5);

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(rounded_cost), "\n"
];