int: K; % number of industries (also used as dimension in provided data)

set of int: I = 1..K;
set of int: T = 0..5;         % years 0..5 (5-year plan)
set of int: TP = 1..5;        % years with consumption requirement

array[I,I] of float: InputOne;        % input coefficients for production
array[I]   of float: ManpowerOne;     % manpower per unit of production

array[I,I] of float: InputTwo;        % input coefficients for capacity investment
array[I]   of float: ManpowerTwo;     % manpower per unit of capacity investment

array[I] of float: Stock;             % initial stock at year 0
array[I] of float: Capacity;          % initial productive capacity at year 0

float: ManpowerLimit;                 % per-year manpower limit
array[I] of float: Demand;            % exogenous yearly consumption requirement (applies years 1..5)

% Decision variables
array[T,I] of var float: x;           % production in year t (value units)
array[T,I] of var float: inv;         % investment in capacity of industry i decided/used in year t
array[T,I] of var float: s;           % end-of-year stock in year t
array[T,I] of var float: cap;         % productive capacity available in year t

% Nonnegativity
constraint forall(t in T, i in I) (
  x[t,i] >= 0 /\ inv[t,i] >= 0 /\ s[t,i] >= 0 /\ cap[t,i] >= 0
);

% Initial conditions
constraint forall(i in I) (
  s[0,i] = Stock[i] /\
  cap[0,i] = Capacity[i]
);

% Capacity availability and evolution:
% Investment inputs used in year t increase capacity in year t+2 (permanent).
constraint forall(t in 0..5, i in I) (
  x[t,i] <= cap[t,i]
);

constraint forall(t in 1..5, i in I) (
  cap[t,i] = cap[t-1,i] + (if t-2 >= 0 then inv[t-2,i] else 0 endif)
);

% Manpower constraint per year (production + investment)
constraint forall(t in T) (
  sum(i in I)(ManpowerOne[i] * x[t,i] + ManpowerTwo[i] * inv[t,i]) <= ManpowerLimit
);

% Material balance with 1-year lag for intermediate inputs for production:
% In year t, available goods = s[t-1] + x[t]
% Uses in year t: intermediate inputs for next year's production (InputOne * x[t+1]),
%                 inputs for investment undertaken in year t (InputTwo * inv[t]),
%                 consumption demand (Demand) for t>=1,
%                 plus ending stock s[t].
% For t=0..4, production in t+1 exists. For t=5, no next-year production in horizon.
constraint forall(t in 0..4, j in I) (
  s[t-1,j] + x[t,j]
  = s[t,j]
    + (if t>=1 then Demand[j] else 0.0 endif)
    + sum(i in I)(InputTwo[j,i] * inv[t,i])
    + sum(i in I)(InputOne[j,i] * x[t+1,i])
);

constraint forall(j in I) (
  s[4,j] + x[5,j]
  = s[5,j]
    + Demand[j]
    + sum(i in I)(InputTwo[j,i] * inv[5,i])
);

% Define s[-1,*] implicitly via year 0 balance by rewriting t=0 constraints:
% Replace s[-1,j] with given initial stock Stock[j].
constraint forall(j in I) (
  Stock[j] + x[0,j]
  = s[0,j]
    + sum(i in I)(InputTwo[j,i] * inv[0,i])
    + sum(i in I)(InputOne[j,i] * x[1,i])
);

% Objective: maximize total productive capacity at end of year 5
solve maximize sum(i in I)(cap[5,i]);

output [
  "TotalCapacityYear5 = ", show(sum(i in I)(cap[5,i])), "\n",
  "CapacityYear5 = ", show([cap[5,i] | i in I]), "\n",
  "Production = ", show([ [x[t,i] | i in I] | t in T ]), "\n",
  "Investment = ", show([ [inv[t,i] | i in I] | t in T ]), "\n",
  "Stock = ", show([ [s[t,i] | i in I] | t in T ]), "\n"
];