% Economic planning / dynamic input-output-capacity expansion model
% Maximizes total productive capacity at the end of the horizon.
%
% Data provided via .dzn:
%   int: K;                               % number of industries (also used as dimension)
%   array[1..K,1..K] of float: InputOne;  % input coefficients for producing 1 unit output (t+1 uses t inputs)
%   array[1..K] of float: ManpowerOne;    % manpower per unit output
%   array[1..K,1..K] of float: InputTwo;  % input coefficients for 1 unit capacity increase
%   array[1..K] of float: ManpowerTwo;    % manpower per unit capacity increase
%   array[1..K] of float: Stock;          % initial stock at year 0
%   array[1..K] of float: Capacity;       % initial capacity at year 0
%   float: ManpowerLimit;                 % yearly manpower limit
%   array[1..K] of float: Demand;         % exogenous consumption requirement each year t=1..T
%
% Note:
% - Planning horizon is fixed at 5 years as per statement.
% - "Demand" is interpreted as required consumption EACH year (t=1..5). If you intend
%   it only for the final year, change the constraint accordingly.

include "globals.mzn";

int: N = K;                 % industries
int: T = 5;                 % years 0..5 (production years 1..5)
set of int: I = 1..N;
set of int: Y = 0..T;

array[I,I] of float: A = InputOne;   % inputs for output
array[I] of float: L = ManpowerOne;  % manpower for output

array[I,I] of float: B = InputTwo;   % inputs for capacity increase
array[I] of float: M = ManpowerTwo;  % manpower for capacity increase

array[I] of float: S0 = Stock;       % initial stocks
array[I] of float: C0 = Capacity;    % initial capacities
float: U = ManpowerLimit;            % yearly manpower limit
array[I] of float: D = Demand;       % consumption requirement

% Decision variables:
% x[t,i] = output produced in year t (t=1..5)
% y[t,i] = capacity increase investment "activity" in year t (t=0..5),
%          which increases capacity in year t+2
% s[t,i] = end-of-year stock in year t (t=0..5)
% c[t,i] = productive capacity available in year t (t=0..5)

array[1..T, I] of var float: x;
array[Y, I] of var float: y;
array[Y, I] of var float: s;
array[Y, I] of var float: c;

% Nonnegativity
constraint forall(t in 1..T, i in I)( x[t,i] >= 0.0 );
constraint forall(t in Y,   i in I)( y[t,i] >= 0.0 /\ s[t,i] >= 0.0 /\ c[t,i] >= 0.0 );

% Initial conditions
constraint forall(i in I)(
    s[0,i] = S0[i] /\
    c[0,i] = C0[i]
);

% Capacity evolution with 2-year lag:
% investment in year t contributes to capacity in year t+2.
constraint forall(t in 0..T-1, i in I)(
    c[t+1,i] = c[t,i] + ( if t-1 >= 0 then y[t-1,i] else 0.0 endif )
);

% Production limited by capacity in same year
constraint forall(t in 1..T, i in I)(
    x[t,i] <= c[t,i]
);

% Goods balance / stock flow:
% In year t (t=0..4), goods produced in year t are available for use in year t
% but production itself requires inputs from previous year (already modeled below).
% Here we account for allocations of goods from year t to:
%   - intermediate inputs for producing x[t+1,*]
%   - investment inputs to y[t,*]
%   - consumption demand D (for t>=1)
% Remaining becomes end-of-year stock s[t,*].
%
% For t=0 there is no consumption requirement.
constraint forall(t in 0..T-1, i in I)(
    s[t,i] + ( if t>=1 then x[t,i] else 0.0 endif )  % production in year t exists only for t>=1
    = 
    sum(j in I)( A[i,j] * x[t+1,j] )                 % inputs for next year's output
  + sum(j in I)( B[i,j] * y[t,j] )                   % inputs for this year's capacity investments
  + ( if t>=1 then D[i] else 0.0 endif )             % consumption (years 1..4 here)
  + s[t+1,i]
);

% For final year t=T: handle stock after meeting investment inputs (y[T,*]) and consumption in year T
constraint forall(i in I)(
    s[T-1,i] + x[T-1,i]
    =
    sum(j in I)( A[i,j] * x[T,j] )
  + sum(j in I)( B[i,j] * y[T-1,j] )
  + D[i]
  + s[T,i]
);

% Additionally, year T production (x[T,*]) must be feasible w.r.t. stocks/inputs already enforced by t=T-1 balance.
% Investment in year T (y[T,*]) uses goods in year T, so we need a separate year-T goods availability:
constraint forall(i in I)(
    s[T,i] + x[T,i]
    >= sum(j in I)( B[i,j] * y[T,j] ) + D[i]
);

% Manpower constraints each year (t=0..5):
% year t manpower used by:
%   - producing x[t,*] (for t>=1)
%   - investing y[t,*]
constraint forall(t in Y)(
    ( if t>=1 then sum(i in I)( L[i] * x[t,i] ) else 0.0 endif )
  + sum(i in I)( M[i] * y[t,i] )
  <= U
);

% Objective: maximize total productive capacity at end of year 5
var float: total_capacity_end = sum(i in I)( c[T,i] );
solve maximize total_capacity_end;

output [
  "TotalCapacityEnd=", show(total_capacity_end), "\n",
  "CapacityEnd=", show([c[T,i] | i in I]), "\n",
  "CapacityByYear=\n", show([ [c[t,i] | i in I] | t in Y ]), "\n",
  "OutputByYear=\n", show([ [x[t,i] | i in I] | t in 1..T ]), "\n",
  "InvestByYear=\n", show([ [y[t,i] | i in I] | t in Y ]), "\n",
  "StockByYear=\n", show([ [s[t,i] | i in I] | t in Y ]), "\n"
];