% Economy planning with K industries over K years
% Maximize total production in the last two years

% --------------------
% Parameters
% --------------------
int: K;

array[1..K, 1..K] of float: InputOne;     % intermediate input coefficients
array[1..K] of float: ManpowerOne;        % manpower per unit production (by industry)

array[1..K, 1..K] of float: InputTwo;     % investment input coefficients
array[1..K] of float: ManpowerTwo;        % manpower per unit investment (by industry)

array[1..K] of float: Stock;              % initial stock by industry (year 0)
array[1..K] of float: Capacity;           % initial capacity by industry (year 0)

float: ManpowerLimit;

% --------------------
% Decision variables
% --------------------
array[0..K] of var float: cap;            % capacity available at start of year t
array[0..K] of var float: stock;          % stock available at end of year t

array[1..K] of var float: prod;           % production in year t
array[1..K] of var float: invest;         % investment in year t (adds capacity in year t+2)

% Nonnegativity
constraint forall(t in 0..K)(cap[t] >= 0.0 /\ stock[t] >= 0.0);
constraint forall(t in 1..K)(prod[t] >= 0.0 /\ invest[t] >= 0.0);

% Initial conditions
constraint forall(i in 1..K)(
  cap[0] = sum(i in 1..K)(0.0)  % dummy to keep MiniZinc happy about i scope
);
constraint forall(i in 1..K)(
  true
);

% Set initial capacity/stock vectors into scalar state by aggregating across industries
% (We model each industry explicitly using an extra index below instead of this scalar version.)
% --- Replace scalar state with per-industry state ---
% To align with input data (K industries), use indexed state:

array[0..K, 1..K] of var float: Cap;
array[0..K, 1..K] of var float: StockV;
array[1..K, 1..K] of var float: Prod;
array[1..K, 1..K] of var float: Invest;

constraint forall(t in 0..K, i in 1..K)(Cap[t,i] >= 0.0 /\ StockV[t,i] >= 0.0);
constraint forall(t in 1..K, i in 1..K)(Prod[t,i] >= 0.0 /\ Invest[t,i] >= 0.0);

constraint forall(i in 1..K)(
  Cap[0,i] = Capacity[i] /\
  StockV[0,i] = Stock[i]
);

% Capacity limits: output in year t limited by capacity at start of year t
constraint forall(t in 1..K, i in 1..K)(
  Prod[t,i] <= Cap[t-1,i]
);

% Manpower limit per year (production + investment)
constraint forall(t in 1..K)(
  sum(i in 1..K)(ManpowerOne[i] * Prod[t,i] + ManpowerTwo[i] * Invest[t,i]) <= ManpowerLimit
);

% Stock balance with 1-year input lag:
% Inputs required for production/investment in year t are taken from stocks of year t-1.
% StockV[t,i] = StockV[t-1,i] + production_i(t) - inputs_from_i_used_for_all_activities(t)
constraint forall(t in 1..K, i in 1..K)(
  StockV[t,i] =
    StockV[t-1,i]
    + Prod[t,i]
    - sum(j in 1..K)(InputOne[i,j] * Prod[t,j] + InputTwo[i,j] * Invest[t,j])
);

% Cannot use more input than available stock at the start of year t (i.e., StockV[t-1,i])
constraint forall(t in 1..K, i in 1..K)(
  sum(j in 1..K)(InputOne[i,j] * Prod[t,j] + InputTwo[i,j] * Invest[t,j]) <= StockV[t-1,i]
);

% Capacity accumulation with 2-year lag:
% Investment in year t increases capacity in year t+2 permanently.
% So for each year t>=1:
% Cap[t,i] = Cap[t-1,i] + (t>=2 ? Invest[t-2,i] : 0)
constraint forall(t in 1..K, i in 1..K)(
  Cap[t,i] = Cap[t-1,i] + (if t >= 2 then Invest[t-2,i] else 0.0 endif)
);

% Objective: maximize total production in the last two years (all industries)
var float: obj =
  sum(i in 1..K)(Prod[K,i]) +
  (if K >= 2 then sum(i in 1..K)(Prod[K-1,i]) else 0.0 endif);

solve maximize obj;