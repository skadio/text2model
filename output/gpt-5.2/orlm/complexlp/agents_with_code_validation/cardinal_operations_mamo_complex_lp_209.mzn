% Star Oil investment LP (fractional investments)
% Uses integer scaling to avoid float-linear limitations in Gecode.

int: nInvest = 5;
set of int: I = 1..nInvest;

% Scale all monetary values by 10 (i.e., 0.1 million precision)
int: S = 10;

int: budget_t0 = 40 * S;   % 400
int: budget_t1 = 20 * S;   % 200

array[I] of int: outflow_t0 = [11*S, 53*S, 5*S, 5*S, 29*S];  % [110,530,50,50,290]
array[I] of int: outflow_t1 = [ 3*S,  6*S, 5*S, 1*S, 34*S];  % [30,60,50,10,340]
array[I] of int: npv        = [13*S, 16*S, 16*S, 14*S, 39*S];% [130,160,160,140,390]

% Decision variables: buy fraction as an integer percent (0..100)
array[I] of var 0..100: x;

% Objective in scaled units (million * 10 * percent)
var int: total_npv = sum(i in I)(npv[i] * x[i]);

% Budgets (independent; no carryover from time 0 to time 1)
constraint sum(i in I)(outflow_t0[i] * x[i]) <= budget_t0 * 100;
constraint sum(i in I)(outflow_t1[i] * x[i]) <= budget_t1 * 100;

solve maximize total_npv;

output [
  "x (percent) = ", show(x), "\n",
  "Max NPV (million $) = ", show( (float(total_npv)) / (float(S) * 100.0) ), "\n"
];