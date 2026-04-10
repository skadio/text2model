% Resource allocation for environmental projects (all data embedded)

int: BUDGET = 5000;

% Effectiveness constraint: 4*X1 + 6*X3 >= 3000
int: eff_min = 3000;

% Logistical constraint: 2*X2 + 3*(X3/2) <= 2500
% To keep integer arithmetic and enforce whole-number allocations, rewrite:
% 2*X2 + (3/2)*X3 <= 2500  <=>  4*X2 + 3*X3 <= 5000
int: log_rhs = 5000;

% Costs per unit
int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

var 0..BUDGET: X1;
var 0..BUDGET: X2;
var 0..BUDGET: X3;

constraint X1 + X2 + X3 <= BUDGET;
constraint 4 * X1 + 6 * X3 >= eff_min;
constraint 4 * X2 + 3 * X3 <= log_rhs;

var int: TotalCost = c1 * X1 + c2 * X2 + c3 * X3;

solve minimize TotalCost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "MinimumTotalCost=", show(TotalCost), "\n"
];