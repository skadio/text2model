% Costs
int: c1 = 100;
int: c2 = 50;
int: c3 = 30;
int: c4 = 200;

% Variable bounds (chosen to make the model finite and avoid solver timeout)
% Upper bounds are safe given constraints and cost minimization:
% x1+x2>=10 and 5*x1-2*x2<=0 imply x1<=4 and x2>=10-x1, so x2<=10 in optimum.
% x3+x4>=20 and 3*x3-x4>=0 imply x3>=5 and x4=20-x3 in optimum, so x3<=20.
var 0..4: x1;
var 0..10: x2;
var 0..20: x3;
var 0..15: x4;

% Constraints
constraint x1 + x2 >= 10;
constraint x3 + x4 >= 20;
constraint 5*x1 - 2*x2 <= 0;
constraint 3*x3 - x4 >= 0;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_cost=", show(c1*x1 + c2*x2 + c3*x3 + c4*x4), "\n"
];