% Star Oil investment planning (fractional investments) - Linear Program
% Data embedded as required.

int: n = 5;
set of int: I = 1..n;

% Cash outflows (million $) at time 0 and time 1
array[I] of float: c0 = [11.0, 53.0, 5.0, 5.0, 29.0];
array[I] of float: c1 = [ 3.0,  6.0, 5.0, 1.0, 34.0];

% Net present value (million $)
array[I] of float: npv = [13.0, 16.0, 16.0, 14.0, 39.0];

% Budgets (million $)
float: B0 = 40.0;
float: B1 = 20.0;

% Decision variables: fraction purchased of each investment
array[I] of var 0.0..1.0: x;

% Budget constraints
constraint sum(i in I)(c0[i] * x[i]) <= B0;
constraint sum(i in I)(c1[i] * x[i]) <= B1;

% Objective: maximize total NPV
var float: total_npv = sum(i in I)(npv[i] * x[i]);

solve maximize total_npv;

output [
  "x = ", show(x), "\n",
  "Total NPV (million $) = ", show(total_npv), "\n",
  "Time0 spend = ", show(sum(i in I)(c0[i] * x[i])), " / ", show(B0), "\n",
  "Time1 spend = ", show(sum(i in I)(c1[i] * x[i])), " / ", show(B1), "\n"
];