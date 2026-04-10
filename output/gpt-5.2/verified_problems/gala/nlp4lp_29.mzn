% Economy planning with lags, capacity building and stocks.
% Data is provided via .dzn.

include "globals.mzn";

int: K;                                % number of industries (and horizon length in provided data)
set of int: I = 1..K;                  % industries
set of int: T = 0..5;                  % years 0..5 (5 years horizon)

array[I] of float: Capacity;           % initial capacity at year 0 (per industry)
array[I] of float: Stock;              % initial stock at beginning of year 0 (per industry)

array[I] of float: Demand;             % exogenous consumption requirement (per year 1..5, constant over time)

array[I] of float: ManpowerOne;        % manpower per unit output (operation 1) for each industry
array[I] of float: ManpowerTwo;        % manpower per unit capacity-building investment (operation 2) for each industry

array[I,I] of float: InputOne;         % input coefficients for production: InputOne[i,j] units of j needed per unit of i output (from prev year)
array[I,I] of float: InputTwo;         % input coefficients for investment: InputTwo[i,j] units of j needed per unit of capacity added to i (from same year)

% -----------------------
% Decision variables
% -----------------------
% Production in year t (value units). Production in year 0 is fixed to 0 (no prior-year inputs defined).
array[T, I] of var float: prod;

% Investment in year t into capacity of industry i (units of permanent capacity added, realized at t+2)
array[T, I] of var float: invest;

% End-of-year stock after satisfying inputs/consumption in year t
array[T, I] of var float: stockEnd;

% Productive capacity available in year t
array[T, I] of var float: cap;

% -----------------------
% Bounds / domains
% -----------------------
constraint forall(t in T, i in I) ( prod[t,i] >= 0.0 /\ invest[t,i] >= 0.0 /\ stockEnd[t,i] >= 0.0 /\ cap[t,i] >= 0.0 );

% No production/investment in year 0 unless you want to allow it; year-0 production requires year -1 inputs, so force to 0.
constraint forall(i in I) ( prod[0,i] = 0.0 );

% -----------------------
% Capacity dynamics (investment in year t increases capacity in year t+2)
% -----------------------
constraint forall(i in I) (
  cap[0,i] = Capacity[i]
);

constraint forall(t in 1..5, i in I) (
  cap[t,i] =
    cap[t-1,i] + ( if t-2 >= 0 then invest[t-2,i] else 0.0 endif )
);

% Capacity limits production each year (year 0 already fixed)
constraint forall(t in 1..5, i in I) (
  prod[t,i] <= cap[t,i]
);

% -----------------------
% Material balance with lags
% In year t>=1, available goods of industry j are:
%   previous end stock + production in year t
% They are used for:
%   (a) production inputs needed for output in year t+1 (InputOne coefficients)
%   (b) investment inputs in year t (InputTwo coefficients)
%   (c) exogenous consumption Demand[j]
% Remaining becomes end stock.
% -----------------------
% Initialize stock at beginning of year 0 is given; define stockEnd[0,*] after year 0 (no demand in year 0 per description).
% Year 0 uses production inputs for year 1 output and investment inputs for year 0 investments (allowed).
% But prod[0,*]=0, so only stock can be used.

% Year 0 balance (no demand)
constraint forall(j in I) (
  Stock[j] + prod[0,j]
  =
  stockEnd[0,j]
  + sum(i in I)( InputOne[i,j] * prod[1,i] )   % inputs in year 0 for year 1 output
  + sum(i in I)( InputTwo[i,j] * invest[0,i] ) % investment inputs in year 0
);

% Years 1..4 balance: inputs for next year's output exist
constraint forall(t in 1..4, j in I) (
  stockEnd[t-1,j] + prod[t,j]
  =
  stockEnd[t,j]
  + Demand[j]
  + sum(i in I)( InputOne[i,j] * prod[t+1,i] )
  + sum(i in I)( InputTwo[i,j] * invest[t,i] )
);

% Year 5 balance: no need to provide inputs for year 6 output (outside horizon)
constraint forall(j in I) (
  stockEnd[4,j] + prod[5,j]
  =
  stockEnd[5,j]
  + Demand[j]
  + sum(i in I)( InputTwo[i,j] * invest[5,i] )
);

% -----------------------
% Objective: maximize total manpower used over years 1..5
% Manpower used = operation1 on production + operation2 on investments
% -----------------------
var float: totalManpower =
  sum(t in 1..5, i in I)( ManpowerOne[i] * prod[t,i] + ManpowerTwo[i] * invest[t,i] );

solve maximize totalManpower;

output [
  "TotalManpower = ", show(totalManpower), "\n",
  "cap = [|\n", concat([ concat([ show(cap[t,i]) ++ (if i==K then "\n" else ", " endif) | i in I ]) | t in T ]), "|]\n",
  "prod = [|\n", concat([ concat([ show(prod[t,i]) ++ (if i==K then "\n" else ", " endif) | i in I ]) | t in T ]), "|]\n",
  "invest = [|\n", concat([ concat([ show(invest[t,i]) ++ (if i==K then "\n" else ", " endif) | i in I ]) | t in T ]), "|]\n",
  "stockEnd = [|\n", concat([ concat([ show(stockEnd[t,i]) ++ (if i==K then "\n" else ", " endif) | i in I ]) | t in T ]), "|]\n"
];