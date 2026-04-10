% Supply chain resource allocation minimization (all data embedded)

int: BUDGET_MAX = 5000;

% To avoid fractions, scale all effectiveness constraints by 2
% 5*X1 - 2.5*X2 >= 1000  ==> 10*X1 - 5*X2 >= 2000
% 3*X2 + 4.5*X3 <= 4000  ==> 6*X2 + 9*X3 <= 8000
% Balance: X1 - 1.5*X2 = X3  ==> 2*X1 - 3*X2 = 2*X3

int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

var 0..BUDGET_MAX: X1;
var 0..BUDGET_MAX: X2;
var 0..BUDGET_MAX: X3;

constraint X1 + X2 + X3 <= BUDGET_MAX;

constraint 10*X1 - 5*X2 >= 2000;

constraint 6*X2 + 9*X3 <= 8000;

constraint 2*X1 - 3*X2 = 2*X3;

var int: total_cost = c1*X1 + c2*X2 + c3*X3;

solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "Minimum total cost (nearest whole number) = ", show(total_cost), "\n"
];