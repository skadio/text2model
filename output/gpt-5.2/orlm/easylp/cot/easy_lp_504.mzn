% Parameters (with values embedded)
int: X1_max = 5000;
int: X2_max = 4000;
int: X3_max = 3000;
int: total_max = 10000;

% Effectiveness: 2*X1 - 3*X2 + 4.5*X3 >= 2000
% Use scaling by 2 to avoid fractions: 4*X1 - 6*X2 + 9*X3 >= 4000
int: eff_min_scaled = 4000;

% Balance constraint:
% "difference between half of X2 and (X1 + three-quarters of X3) should not exceed 1500"
% Interpret as absolute difference: |0.5*X2 - (X1 + 0.75*X3)| <= 1500
% Scale by 4: |2*X2 - (4*X1 + 3*X3)| <= 6000
int: balance_max_scaled = 6000;

int: c1 = 5000;
int: c2 = 3000;
int: c3 = 7000;

% Variables
var 0..X1_max: X1;
var 0..X2_max: X2;
var 0..X3_max: X3;

var 0..(c1*X1_max + c2*X2_max + c3*X3_max): TotalCost;

% Constraints
constraint X1 + X2 + X3 <= total_max;

constraint 4*X1 - 6*X2 + 9*X3 >= eff_min_scaled;

constraint abs(2*X2 - (4*X1 + 3*X3)) <= balance_max_scaled;

constraint TotalCost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize TotalCost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "Minimum total cost (dollars)=", show(TotalCost), "\n"
];