% Economy planning / capacity expansion with lags
% Indices:
%   industries i,j in 1..KInd
%   years t in 0..T  (year 0 is the initial year)
%
% NOTE: Input data uses the name K for the number of industries.
%       The planning horizon in years is fixed to 5 as per description.

int: K;                      % number of industries (from data)
int: T = 5;                  % planning horizon (years 1..T), year 0 is initial

set of int: IND = 1..K;
set of int: Y0T = 0..T;
set of int: Y1T = 1..T;

array[IND] of float: ManpowerOne;     % manpower per unit production for industry i
array[IND] of float: ManpowerTwo;     % manpower per unit capacity-building for industry i

array[IND] of float: Stock;           % initial stock at beginning of year 0
array[IND] of float: Capacity;        % initial capacity available in year 0

array[IND] of float: Demand;          % exogenous consumption requirement each year t>=1

array[IND, IND] of float: InputOne;   % InputOne[i,j]: input from industry j per unit output of industry i (for next year)
array[IND, IND] of float: InputTwo;   % InputTwo[i,j]: input from industry j per unit capacity increase of industry i

% Decision variables
array[Y0T, IND] of var float: x;      % x[t,i] production of industry i in year t
array[Y0T, IND] of var float: y;      % y[t,i] capacity-building for industry i using year t inputs (effective from t+2)
array[Y0T, IND] of var float: s;      % s[t,i] stock at beginning of year t
array[Y0T, IND] of var float: cap;    % cap[t,i] capacity available in year t

var float: TotalManpower;

% Initial conditions
constraint forall(i in IND) (
  s[0,i] = Stock[i] /\
  cap[0,i] = Capacity[i]
);

% Nonnegativity
constraint forall(t in Y0T, i in IND) (
  x[t,i] >= 0.0 /\
  y[t,i] >= 0.0 /\
  s[t,i] >= 0.0 /\
  cap[t,i] >= 0.0
);

% Production limited by capacity
constraint forall(t in Y0T, i in IND) (
  x[t,i] <= cap[t,i]
);

% Capacity evolution: investment in year t increases capacity starting year t+2 (permanent)
constraint forall(i in IND) (
  cap[1,i] = cap[0,i]
);
constraint forall(t in 2..T, i in IND) (
  cap[t,i] = cap[t-1,i] + y[t-2,i]
);

% Material balances with one-year lag for production inputs
% Year 0: no demand; allocate to inputs for year 1 production and/or to building; define s[1]
constraint forall(j in IND) (
  s[0,j] + x[0,j]
  =
    sum(i in IND)(InputOne[i,j] * x[1,i])     % inputs from j needed for year-1 production of i
  + sum(i in IND)(InputTwo[i,j] * y[0,i])     % inputs from j needed for building aimed at i
  + s[1,j]
);

% Years 1..T-1: meet demand and allocate inputs for next year's production and building
constraint forall(t in 1..T-1, j in IND) (
  s[t,j] + x[t,j]
  =
    Demand[j]
  + sum(i in IND)(InputOne[i,j] * x[t+1,i])
  + sum(i in IND)(InputTwo[i,j] * y[t,i])
  + s[t+1,j]
);

% Final year T: no next-year production within horizon
constraint forall(j in IND) (
  s[T,j] + x[T,j]
  =
    Demand[j]
  + sum(i in IND)(InputTwo[i,j] * y[T,i])
  % no s[T+1,*] variable; leftover is allowed to be unused
);

% Total manpower over years 1..T (exclude year 0)
constraint TotalManpower =
  sum(t in Y1T)(
      sum(i in IND)(ManpowerOne[i] * x[t,i])
    + sum(i in IND)(ManpowerTwo[i] * y[t,i])
  );

solve maximize TotalManpower;