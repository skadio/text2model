% Parameters
int: K;  % number of industries (and years in the horizon, per provided data)
set of int: I = 1..K;
set of int: T = 0..5;            % years 0..5
set of int: Tprod = 0..4;        % production decisions affect t+1, so need t<=4
set of int: Tinv  = 0..3;        % investment decisions affect t+2, so need t<=3
set of int: Treq  = 1..5;        % consumption requirement applies every year except 0

array[I,I] of float: InputOne;   % intermediate input coefficients for production
array[I] of float: ManpowerOne;  % manpower per unit of production

array[I,I] of float: InputTwo;   % input coefficients for capacity expansion (investment)
array[I] of float: ManpowerTwo;  % manpower per unit of capacity expansion

array[I] of float: Stock;        % initial stocks at year 0
array[I] of float: Capacity;     % initial productive capacity at year 0

float: ManpowerLimit;            % yearly manpower limit
array[I] of float: Demand;       % exogenous consumption requirement per year (t=1..5)

% Variables
array[T, I] of var float: S;     % end-of-year stock (inventory)
array[Tprod, I] of var float: P; % production in year t (becomes available in t+1)
array[Tinv, I] of var float: X;  % investment in year t yielding capacity in t+2
array[T, I] of var float: Cap;   % productive capacity available in year t

% Constraints
constraint forall(i in I) (
  S[0,i] = Stock[i] /\
  Cap[0,i] = Capacity[i]
);

constraint forall(t in T, i in I) (
  S[t,i] >= 0.0 /\ Cap[t,i] >= 0.0
);

constraint forall(t in Tprod, i in I) (
  P[t,i] >= 0.0
);

constraint forall(t in Tinv, i in I) (
  X[t,i] >= 0.0
);

% Production cannot exceed available capacity in that year
constraint forall(t in Tprod, i in I) (
  P[t,i] <= Cap[t,i]
);

% Capacity evolution: investment in year t-2 increases capacity permanently from year t onward
constraint forall(t in 1..5, i in I) (
  Cap[t,i] = Cap[t-1,i] + ( if t >= 2 then X[t-2,i] else 0.0 endif )
);

% Inventory balance:
% S[t,i] = S[t-1,i] + P[t-1,i] - intermediate_inputs_for_production_in_year_t - investment_goods_in_year_t - consumption_in_year_t
constraint forall(t in 1..5, i in I) (
  S[t,i] =
    S[t-1,i]
    + P[t-1,i]
    - sum(j in I)(InputOne[j,i] * P[t,i])                  % goods i used as input for production in year t across all output industries j
    - ( if t <= 3 then sum(j in I)(InputTwo[j,i] * X[t,j]) else 0.0 endif )  % goods i used for investment in year t
    - Demand[i]                                           % exogenous consumption requirement
);

% Manpower limit each year (production year t uses ManpowerOne; investment year t uses ManpowerTwo)
constraint forall(t in 1..4) (
  sum(i in I)(ManpowerOne[i] * P[t,i]) +
  sum(i in I)( if t <= 3 then ManpowerTwo[i] * X[t,i] else 0.0 endif )
  <= ManpowerLimit
);

% Also enforce manpower for year 0 decisions (P[0,*], X[0,*]) if used
constraint
  sum(i in I)(ManpowerOne[i] * P[0,i]) +
  sum(i in I)(ManpowerTwo[i] * X[0,i])
  <= ManpowerLimit;

% Objective
solve maximize sum(i in I)(Cap[5,i]);