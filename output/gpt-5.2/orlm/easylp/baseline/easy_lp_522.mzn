int: risk1 = 2;
int: risk2 = 3;
int: risk3 = 4;

int: ret1 = 5;
int: ret2 = 7;
int: ret3 = 8;

int: minReturn = 1500;

% Bounds not specified in the description; assume nonnegative investments.
int: lb1 = 0; int: ub1 = 100000;
int: lb2 = 0; int: ub2 = 100000;
int: lb3 = 0; int: ub3 = 100000;

var lb1..ub1: X1;
var lb2..ub2: X2;
var lb3..ub3: X3;

constraint ret1*X1 + ret2*X2 + ret3*X3 >= minReturn;

% X1 - (3/4)X2 - (1/2)X3 <= 200  ->  4X1 - 3X2 - 2X3 <= 800
constraint 4*X1 - 3*X2 - 2*X3 <= 800;

% 2X2 - X1 - X3 = 400
constraint 2*X2 - X1 - X3 = 400;

var int: total_risk = risk1*X1 + risk2*X2 + risk3*X3;

solve minimize total_risk;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "total_risk=", show(total_risk), "\n",
  "rounded_total_risk=", show(round(int2float(total_risk))), "\n"
];