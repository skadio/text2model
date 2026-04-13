int: K; % number of industries (and planning years = 5 implied by statement, but data provides K)
set of int: I = 1..K;
set of int: T = 0..5;

array[I,I] of float: InputOne;      % intermediate input coefficients for production (from i to produce j)
array[I]   of float: ManpowerOne;   % manpower per unit of production in industry j

array[I,I] of float: InputTwo;      % input coefficients to build 1 unit of capacity in industry j (from i)
array[I]   of float: ManpowerTwo;   % manpower per unit of capacity built in industry j

array[I] of int: Stock;             % initial stock at year 0
array[I] of int: Capacity;          % initial productive capacity at year 0
float: ManpowerLimit;               % yearly manpower limit
array[I] of float: Demand;          % exogenous consumption requirement per year (years 1..5)

% -------------------------
% Decision variables
% -------------------------
array[T, I] of var float: prod;        % production in year t (t=0..5)
array[T, I] of var float: stock;       % end-of-year stock in year t
array[T, I] of var float: cap;         % productive capacity available in year t

array[T, I] of var float: invest;      % "investment activity" in year t that yields +invest[t,j] capacity in year t+2

% Helper: total usage of each good i in year t for production, investment, and consumption
array[T, I] of var float: use_prod;    % used as intermediate for production
array[T, I] of var float: use_inv;     % used as inputs for investment
array[T, I] of var float: cons;        % consumption (exogenous for t>=1, 0 for t=0)

% Nonnegativity
constraint forall(t in T, i in I) (
  prod[t,i] >= 0.0 /\ stock[t,i] >= 0.0 /\ cap[t,i] >= 0.0 /\ invest[t,i] >= 0.0
);

% Consumption requirements: every year except year 0
constraint forall(i in I) (cons[0,i] = 0.0);
constraint forall(t in 1..5, i in I) (cons[t,i] = Demand[i]);

% Initial conditions
constraint forall(i in I) (
  stock[0,i] = float(Stock[i]) /\
  cap[0,i]   = float(Capacity[i])
);

% Capacity evolution with 2-year lag: investment in year t adds to capacity in year t+2 (permanent)
constraint forall(i in I) (
  cap[1,i] = cap[0,i]  % nothing matures yet
);
constraint forall(t in 2..5, i in I) (
  cap[t,i] = cap[t-1,i] + invest[t-2,i]
);

% Production limited by capacity each year
constraint forall(t in T, i in I) (
  prod[t,i] <= cap[t,i]
);

% Compute intermediate uses for production and investment
constraint forall(t in T, i in I) (
  use_prod[t,i] = sum(j in I)(InputOne[i,j] * prod[t,j])
);
constraint forall(t in T, i in I) (
  use_inv[t,i] = sum(j in I)(InputTwo[i,j] * invest[t,j])
);

% Stock balance with one-year lag for production inputs:
% outputs in year t become available for use (production inputs, investment inputs, consumption) in year t+1.
% Thus goods available in year t are stock[t-1] (end of last year) + prod[t-1].
constraint forall(i in I) (
  % year 0 has only initial stock available; no production from year -1
  stock[0,i] >= 0.0
);
constraint forall(t in 1..5, i in I) (
  stock[t,i] = stock[t-1,i] + prod[t-1,i] - use_prod[t,i] - use_inv[t,i] - cons[t,i]
);

% Ensure feasibility of year 0 usage: no consumption and no inputs can be used in year 0 (since available is only stock[-1] not defined)
% We enforce zero usage in year 0 by setting production inputs and investment inputs to zero at t=0.
constraint forall(i in I) (
  use_prod[0,i] = 0.0 /\ use_inv[0,i] = 0.0
);

% Manpower limit per year:
% manpower used in year t comes from production and investment activities performed in year t.
constraint forall(t in T) (
  sum(j in I)(ManpowerOne[j] * prod[t,j] + ManpowerTwo[j] * invest[t,j]) <= ManpowerLimit
);

% Objective: maximize total productive capacity at end of year 5
var float: total_final_capacity = sum(i in I)(cap[5,i]);
solve maximize total_final_capacity;

output [
  "total_final_capacity=", show(total_final_capacity), "\n",
  "cap_5=", show([cap[5,i] | i in I]), "\n",
  "invest_by_year=", show([ [invest[t,i] | i in I] | t in T ]), "\n",
  "prod_by_year=", show([ [prod[t,i] | i in I] | t in T ]), "\n",
  "stock_by_year=", show([ [stock[t,i] | i in I] | t in T ]), "\n"
];