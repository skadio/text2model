int: c1 = 5000;
int: c2 = 4000;
int: c3 = 6000;
int: c4 = 7000;

int: ub1 = 30;
int: ub2 = 40;
int: ub3 = 50;
int: ub4 = 60;

var 0..ub1: X1;
var 0..ub2: X2;
var 0..ub3: X3;
var 0..ub4: X4;

constraint X1 + X2 >= 10;
constraint X3 + X4 <= 20;
constraint 2*X2 - X1 - X3 >= 5;
constraint X4 - X1 - X2 >= 5;

var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n"
];