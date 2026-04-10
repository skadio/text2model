% Financial management investment optimization (all data embedded)

int: max12 = 1000;
int: max34 = 500;

float: r1 = 0.05;
float: r2 = 0.07;
float: loss3 = -0.03;
float: loss4 = -0.04;

int: minReturn12 = 50;
int: minLossLimit34 = -20;

int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

% Decision variables: integer investment units
var 0..max12: X1;
var 0..max12: X2;
var 0..max34: X3;
var 0..max34: X4;

% Constraints
constraint X1 + X2 <= max12;

% Avoid floats by scaling by 100:
% 0.05*X1 + 0.07*X2 >= 50  <=>  5*X1 + 7*X2 >= 5000
constraint 5*X1 + 7*X2 >= 5000;

constraint X3 + X4 <= max34;

% -0.03*X3 + -0.04*X4 >= -20  (i.e., net loss should not be worse than -20)
% Scale by 100:
% -3*X3 - 4*X4 >= -2000  <=>  3*X3 + 4*X4 <= 2000
constraint 3*X3 + 4*X4 <= 2000;

% Objective: minimize total cost
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;
solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n"
];