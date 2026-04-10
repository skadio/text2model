% Investment strategy - minimize total risk
% Assets: Bond1, Bond2, Stock1, Stock2

int: n = 4;
set of int: A = 1..n;

int: Bond1 = 1;
int: Bond2 = 2;
int: Stock1 = 3;
int: Stock2 = 4;

array[A] of int: risk = [2, 3, 4, 5];

% Individual bounds (not explicitly specified); use nonnegative investments.
% Upper bounds chosen large enough so only portfolio constraints bind.
array[A] of int: lb = [0, 0, 0, 0];
array[A] of int: ub = [10000, 10000, 5000, 5000];

array[A] of var int: x;
constraint forall(i in A)(lb[i] <= x[i] /\ x[i] <= ub[i]);

% Category limits
constraint x[Bond1] + x[Bond2] <= 10000;
constraint x[Stock1] + x[Stock2] <= 5000;

% Diversification / balance constraints
constraint x[Bond1] >= x[Stock1] + 2000;
constraint x[Stock2] >= x[Bond2] + 1000;

% Objective: minimize total risk score (risk units per $ invested)
var int: total_risk = sum(i in A)(risk[i] * x[i]);

solve minimize total_risk;

output [
  "Bond1=", show(x[Bond1]), "\n",
  "Bond2=", show(x[Bond2]), "\n",
  "Stock1=", show(x[Stock1]), "\n",
  "Stock2=", show(x[Stock2]), "\n",
  "TotalRisk=", show(total_risk), "\n",
  "MinTotalRiskRounded=", show(total_risk), "\n"
];