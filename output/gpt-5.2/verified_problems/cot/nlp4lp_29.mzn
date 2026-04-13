% Parameters
int: K; % number of industries (also used as products dimension)
set of int: I = 1..K;
set of int: T = 0..5;           % years 0..5 (given: maximize over five years)
set of int: TY = 0..4;          % production decisions affecting manpower in years 0..4 (t+1 within 1..5)

array[I] of float: ManpowerOne;
array[I] of float: ManpowerTwo;

array[I] of float: Stock;       % initial stock at beginning of year 0
array[I] of float: Capacity;    % initial capacity in year 0
array[I] of float: Demand;      % exogenous consumption requirement each year for years 1..5

array[I, I] of float: InputOne; % input coeffs: for output of industry i, requires InputOne[i,j] of product j (op 1)
array[I, I] of float: InputTwo; % input coeffs: for capacity-build of industry i, requires InputTwo[i,j] of product j (op 2)

% Variables
array[TY, I] of var float: x;      % x[t,i] = output of industry i produced in year t (used in year t+1)
array[TY, I] of var float: y;      % y[t,i] = capacity increase investments made in year t (becomes capacity in year t+2)
array[T,  I] of var float: s;      % s[t,i] = stock at beginning of year t
array[T,  I] of var float: cap;    % cap[t,i] = productive capacity available in year t

% Constraints
constraint forall(t in TY, i in I)( x[t,i] >= 0.0 );
constraint forall(t in TY, i in I)( y[t,i] >= 0.0 );
constraint forall(t in T,  i in I)( s[t,i] >= 0.0 );
constraint forall(t in T,  i in I)( cap[t,i] >= 0.0 );

% Initial conditions (year 0)
constraint forall(i in I)( s[0,i] = Stock[i] );
constraint forall(i in I)( cap[0,i] = Capacity[i] );

% Capacity evolution with 2-year lag: investment in year t adds to cap[t+2]
constraint forall(i in I)( cap[1,i] = cap[0,i] );
constraint forall(t in 0..3, i in I)( cap[t+2,i] = cap[t+1,i] + y[t,i] );

% Production bounded by capacity in that year (years 0..4)
constraint forall(t in TY, i in I)( x[t,i] <= cap[t,i] );

% Material balance each year: beginning stock + production available (from last year) covers
% (i) intermediate input for next year's production, (ii) investment inputs, (iii) final demand, and leaves ending stock.
% Inputs/consumption are taken from goods available in the same year.
constraint forall(t in 0..4, j in I)(
  s[t,j] + (if t = 0 then 0.0 else x[t-1,j] endif)
  =
  sum(i in I)( InputOne[i,j] * x[t,i] )      % inputs to produce year t output (used in year t+1)
  + sum(i in I)( InputTwo[i,j] * y[t,i] )    % goods used for capacity build in year t
  + (if t = 0 then 0.0 else Demand[j] endif) % exogenous consumption for years 1..4 (year 0 excluded)
  + s[t+1,j]
);

% In year 5: only demand must be met from beginning stock + year 4 production; no further production/investment
constraint forall(j in I)(
  s[5,j] = s[4,j] + x[4,j] - Demand[j]
);

% Objective
solve maximize
  sum(t in TY, i in I)(
    ManpowerOne[i] * x[t,i] + ManpowerTwo[i] * y[t,i]
  );