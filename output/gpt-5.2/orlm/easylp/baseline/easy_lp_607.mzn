int: X1_min = 0;
int: X1_max = 2000;
int: X2_min = 0;
int: X2_max = 1500;
int: X3_min = 500;
int: X3_max = 1500;
int: X4_min = 500;
int: X4_max = 2000;

var X1_min..X1_max: X1;
var X2_min..X2_max: X2;
var X3_min..X3_max: X3;
var X4_min..X4_max: X4;

constraint X1 + X2 <= 5000;
constraint X2 >= X3 + 1000;
constraint X3 + 2 * X4 <= 3000;
constraint X4 >= X1 + 100;

% Objective (cost in thousands):
% costs: 0.5, 0.3, 0.4, 0.6 per unit
% Minimize 0.5*X1 + 0.3*X2 + 0.4*X3 + 0.6*X4
% To avoid floating-point optimization, minimize 10x cost:
% 10*cost = 5*X1 + 3*X2 + 4*X3 + 6*X4
var int: obj10 = 5*X1 + 3*X2 + 4*X3 + 6*X4;

solve minimize obj10;

% Compute one-decimal rounded cost in thousands:
% cost = obj10 / 10.0
% rounded_1dp = round(cost*10)/10 = round(obj10)/10, since cost*10 = obj10
var int: rounded10 = round(int2float(obj10)); % integer representing 10 * rounded_cost
var float: min_cost_thousands_1dp = int2float(rounded10) / 10.0;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "Minimum total cost (thousands), 1dp: ", show(min_cost_thousands_1dp), "\n"
];