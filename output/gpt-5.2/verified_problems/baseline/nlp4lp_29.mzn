% Economy planning with lags, stocks, two types of operations:
% - Operation 1: current production (year t) requiring last year's outputs as intermediate inputs
% - Operation 2: investment/capacity-building (year t) requiring last year's outputs as inputs,
%   which increases productive capacity permanently starting year t+2.
%
% Objective: maximize total manpower used over the planning horizon.

include "float.mzn";

% -----------------------
% Data (from .dzn)
% -----------------------
int: K;  % number of industries AND number of modeled years with requirements (years 1..K)

array[1..K] of float: ManpowerOne;     % manpower per unit of operation 1 output of industry i
array[1..K] of float: ManpowerTwo;     % manpower per unit of operation 2 (capacity unit) for industry i

array[1..K] of float: Stock;           % initial stock of each industry's product at beginning of year 1
array[1..K] of float: Capacity;        % initial production capacity in year 1 for each industry
array[1..K] of float: Demand;          % exogenous consumption requirement each year (years 1..K)

array[1..K, 1..K] of float: InputOne;  % inputs from industry j needed per unit op1 output of industry i
array[1..K, 1..K] of float: InputTwo;  % inputs from industry j needed per unit op2 (capacity) of industry i

% -----------------------
% Modeling choices
% -----------------------
set of int: I = 1..K;
set of int: T = 1..K;

% Upper bounds (kept generous; can be tightened via data if desired)
float: BIG = 1.0e12;

% Decision variables
array[T, I] of var 0.0..BIG: x1;  % operation 1 output (production) in year t, industry i
array[T, I] of var 0.0..BIG: x2;  % operation 2 activity (capacity additions) in year t, industry i

array[T, I] of var 0.0..BIG: s;   % end-of-year stock of product i after year t

array[T, I] of var 0.0..BIG: cap; % available production capacity in year t for industry i

% Helper: total output of industry j in year t (available at end of year t for use in t+1)
array[T, I] of var 0.0..BIG: out;

constraint forall(t in T, j in I) (
  out[t,j] = x1[t,j] + x2[t,j]
);

% -----------------------
% Capacity dynamics
% -----------------------
% cap[1,i] is given by Capacity[i]
constraint forall(i in I) (
  cap[1,i] = Capacity[i]
);

% Capacity in year t (t>=2) equals initial capacity plus all investments made up to year t-2
% (investment in year u becomes available in year u+2, and is permanent thereafter)
constraint forall(t in 2..K, i in I) (
  cap[t,i] = Capacity[i] + sum(u in 1..K where u <= t-2)( x2[u,i] )
);

% Capacity limit on operation 1 output (production)
constraint forall(t in T, i in I) (
  x1[t,i] <= cap[t,i]
);

% -----------------------
% Flow balance with one-year input lag and end-of-year stocks
% -----------------------
% For year 1: inputs must come from initial stock at beginning of year 1.
% For year t>=2: inputs must come from previous year's outputs (out[t-1,*]) plus previous stock s[t-1,*].
%
% Goods of industry j available in year t for allocation:
%   avail(t,j) = (t==1 ? Stock[j] : s[t-1,j] + out[t-1,j])
% Used in year t for:
%   - intermediate inputs to x1[t,*] per InputOne
%   - inputs to investment x2[t,*] per InputTwo
%   - consumption Demand[j]
%   - ending stock s[t,j]
%
% Balance for each year t and product j:
%   avail(t,j) = Demand[j] + sum_i InputOne[i,j]*x1[t,i] + sum_i InputTwo[i,j]*x2[t,i] + s[t,j]

constraint forall(j in I) (
  Stock[j] =
    Demand[j]
  + sum(i in I)( InputOne[i,j] * x1[1,i] )
  + sum(i in I)( InputTwo[i,j] * x2[1,i] )
  + s[1,j]
);

constraint forall(t in 2..K, j in I) (
  s[t-1,j] + out[t-1,j] =
    Demand[j]
  + sum(i in I)( InputOne[i,j] * x1[t,i] )
  + sum(i in I)( InputTwo[i,j] * x2[t,i] )
  + s[t,j]
);

% -----------------------
% Objective: maximize total manpower over the horizon
% -----------------------
var float: total_manpower =
  sum(t in T, i in I)( ManpowerOne[i] * x1[t,i] + ManpowerTwo[i] * x2[t,i] );

solve maximize total_manpower;

% -----------------------
% Output
% -----------------------
output [
  "total_manpower = ", show(total_manpower), "\n",
  "x1 (op1 production) =\n", show(x1), "\n",
  "x2 (op2 investment) =\n", show(x2), "\n",
  "cap =\n", show(cap), "\n",
  "end stocks s =\n", show(s), "\n"
];