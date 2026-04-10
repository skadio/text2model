int: costX = 2;
int: costY = 3;
int: costZ = 4;
int: costW = 5;

int: eq1_rhs = 50;
int: eq2_rhs = 100;
int: eq3_rhs = 20;
int: eq4_rhs = 30;

var 0..200: X;
var 0..200: Y;
var 0..200: Z;
var 0..200: W;

var 0..200: s1;
var 0..200: s2;
var 0..200: s3;
var 0..200: s4;

var int: total_cost;

constraint X + Y - s1 = eq1_rhs;
constraint Y + Z - s2 = eq2_rhs;
constraint Z - W + s3 = eq3_rhs;
constraint X - W + s4 = eq4_rhs;

constraint total_cost = costX * X + costY * Y + costZ * Z + costW * W;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "s1=", show(s1), " s2=", show(s2), " s3=", show(s3), " s4=", show(s4), "\n",
  "total_cost=", show(total_cost), "\n"
];