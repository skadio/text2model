% Manufacturing production planning (integer linear optimization)

% Costs per unit
int: c1 = 5;
int: c2 = 10;
int: c3 = 20;
int: c4 = 25;

% Production bounds (not specified numerically in the prompt; use safe, implied limits)
% X1 and X2 are limited by X1+X2 <= 100, so each is in 0..100.
% X4 has an explicit maximum of 200; X3 is implicitly limited by the ratio with X4.
var 0..100: X1;
var 0..100: X2;
var 0..200: X3;
var 0..200: X4;

% Constraints
constraint X1 + X2 <= 100;

% "For every 2 units of X3 produced, 3 units of X4 can be made within a maximum limit of 200 units."
% Interpreted as a fixed production ratio: X4 = (3/2) * X3, hence 2*X4 = 3*X3
constraint 2 * X4 = 3 * X3;
constraint X4 <= 200;

% X1 - 2*X2 + X3 >= 50
constraint X1 - 2 * X2 + X3 >= 50;

% "The difference between the numbers of products made for type-x2,x3, subtracted from type-x1, should not exceed 70."
% Interpreted as: X1 - (X2 - X3) <= 70  i.e., X1 - X2 + X3 <= 70
constraint X1 - X2 + X3 <= 70;

% Objective: minimize total cost
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "X4 = ", show(X4), "\n",
  "Total cost = $", show(total_cost), "\n"
];