% Teacher allocation among 4 schools with surplus variables
% Minimize total cost subject to linear balance constraints.

int: costX = 2;
int: costY = 3;
int: costZ = 4;
int: costW = 5;

% Decision variables: number of teachers at each school (nonnegative integers)
var 0..200: X;
var 0..200: Y;
var 0..200: Z;
var 0..200: W;

% Surplus variables (nonnegative integers)
var 0..200: s1;
var 0..200: s2;
var 0..200: s3;
var 0..200: s4;

% Constraints from the description
constraint X + Y - s1 = 50;
constraint Y + Z - s2 = 100;
constraint Z - W + s3 = 20;
constraint X - W + s4 = 30;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y + costZ*Z + costW*W;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "s1=", show(s1), " s2=", show(s2), " s3=", show(s3), " s4=", show(s4), "\n",
  "total_cost=", show(total_cost), "\n"
];