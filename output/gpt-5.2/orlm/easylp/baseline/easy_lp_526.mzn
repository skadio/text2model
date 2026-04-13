% Resource allocation optimization for three departments (X1, X2, X3)
% All data embedded; integer allocations; minimize total cost.

int: max_total = 5000;

int: max_x1 = 3000;
int: max_x2 = 2500;
int: max_x3 = 1500;

int: cost_x1 = 50;
int: cost_x2 = 75;
int: cost_x3 = 60;

% Effectiveness constraint: 0.5*X1 + 0.4*X2 + 0.6*X3 >= 2000
% Multiply by 10 to avoid decimals: 5*X1 + 4*X2 + 6*X3 >= 20000
int: eff_min_times10 = 20000;

% Balance constraint: |2*X2 - (X1 + X3)| <= 100
int: balance_tol = 100;

var 0..max_x1: X1;
var 0..max_x2: X2;
var 0..max_x3: X3;

constraint X1 + X2 + X3 <= max_total;

constraint 5*X1 + 4*X2 + 6*X3 >= eff_min_times10;

constraint abs(2*X2 - (X1 + X3)) <= balance_tol;

var int: total_cost = cost_x1*X1 + cost_x2*X2 + cost_x3*X3;

solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "Minimum total cost (nearest dollar)=", show(total_cost), "\n"
];