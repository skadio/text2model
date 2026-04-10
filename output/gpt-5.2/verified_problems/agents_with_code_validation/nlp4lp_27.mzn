% ------------------------------------------------------------
% Model: Multi-industry planning with lags, stocks, capacity expansion
% Fix for compilation error:
%   Use bounded float variables (Gecode Float::linear limit) and ensure
%   all linear constraints stay within solver limits.
% ------------------------------------------------------------

% --------------------
% Parameters (from .dzn)
% --------------------
int: K;                                      % Number of industries
set of int: I = 1..K;

array[I, I] of float: InputOne;              % Inputs for production (year t inputs -> year t+1 output)
array[I] of float: ManpowerOne;              % Manpower per unit of output

array[I, I] of float: InputTwo;              % Inputs for investment (capacity increase)
array[I] of float: ManpowerTwo;              % Manpower per unit of investment

array[I] of float: Stock;                    % Initial stocks at year 0
array[I] of float: Capacity;                 % Initial capacity at year 0

float: ManpowerLimit;                        % Annual manpower limit
array[I] of float: Demand;                   % Annual consumption requirement (years 1..T)

% --------------------
% Horizon (fixed)
% --------------------
int: T = 5;
set of int: Y = 0..T;
set of int: Ypos = 1..T;

% --------------------
% Safe variable bounds (avoid Gecode Float::linear "Number out of limits")
% --------------------
float: UB_stock = 1.0e12;
float: UB_flow  = 1.0e12;
float: UB_cap   = 1.0e12;

% --------------------
% Decision variables
% --------------------
array[Y, I] of var 0.0..UB_flow: production;   % produced in year y (available year y+1)
array[Y, I] of var 0.0..UB_stock: stock;       % end-of-year stock
array[Y, I] of var 0.0..UB_cap: capacity;      % productive capacity available in year y
array[Y, I] of var 0.0..UB_flow: invest;       % investment started in year y (adds capacity in y+2)

var 0.0..(K * UB_cap): total_capacity_end;

% --------------------
% Initial conditions
% --------------------
constraint forall(i in I) (stock[0,i] = Stock[i]);
constraint forall(i in I) (capacity[0,i] = Capacity[i]);

% --------------------
% Production limited by capacity
% --------------------
constraint forall(y in Y, i in I) (production[y,i] <= capacity[y,i]);

% --------------------
% Capacity evolution (2-year lag)
% capacity[y] = capacity[y-1] + invest[y-2] for y>=2, else no add
% --------------------
constraint forall(y in 1..T, i in I) (
  capacity[y,i] = capacity[y-1,i] + (if y >= 2 then invest[y-2,i] else 0.0 endif)
);

% --------------------
% Stock-flow balance (years 1..T)
% Available in year y: stock[y-1,i] + production[y-1,i]
% Used in year y: intermediate inputs for production[y,*], investment inputs for invest[y,*], and demand
% --------------------
constraint forall(y in Ypos, i in I) (
  stock[y,i] =
    stock[y-1,i]
    + production[y-1,i]
    - sum(j in I) (InputOne[i,j] * production[y,j])
    - sum(j in I) (InputTwo[i,j] * invest[y,j])
    - Demand[i]
);

% --------------------
% No actions with effects outside horizon
% --------------------
constraint forall(i in I) (production[T,i] = 0.0);
constraint forall(i in I) (invest[T,i] = 0.0);
constraint forall(i in I) (invest[T-1,i] = 0.0);

% --------------------
% Annual manpower limit (years 0..T-1)
% --------------------
constraint forall(y in 0..T-1) (
  sum(i in I) (ManpowerOne[i] * production[y,i] + ManpowerTwo[i] * invest[y,i]) <= ManpowerLimit
);

% --------------------
% Objective: maximize total productive capacity at end of year T
% --------------------
constraint total_capacity_end = sum(i in I) (capacity[T,i]);

solve maximize total_capacity_end;