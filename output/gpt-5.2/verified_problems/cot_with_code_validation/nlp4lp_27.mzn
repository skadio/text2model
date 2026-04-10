% Economy planning with lags (K years, also number of industries)

% -----------------------------
% Parameters
% -----------------------------
int: K;                    % planning horizon (years 1..K), also number of industries
set of int: I = 1..K;
set of int: T = 0..K;      % years including year 0
set of int: Tp = 0..K-1;   % decision years for production/investment that affect year t+1

array[I,I] of float: InputOne;   % inputs (from industry j) per unit output of industry i (used with 1-year lag)
array[I]   of float: ManpowerOne;

array[I,I] of float: InputTwo;   % inputs (from industry j) per unit capacity increase of industry i (investment, available after 2 years)
array[I]   of float: ManpowerTwo;

array[I] of float: Stock;        % initial stock at end of year 0
array[I] of float: Capacity;     % productive capacity available in year 0
float: ManpowerLimit;            % yearly manpower limit
array[I] of float: Demand;       % exogenous consumption requirement per year (years 1..K)

% -----------------------------
% Variables
% -----------------------------
array[I, T]  of var float: S;      % end-of-year stock
array[I, T]  of var float: Cap;    % productive capacity available in each year
array[I, Tp] of var float: X;      % output produced in year t
array[I, Tp] of var float: Inv;    % investment started in year t (adds capacity in year t+2)

% -----------------------------
% Constraints
% -----------------------------
% Nonnegativity
constraint forall(i in I, t in T)(S[i,t] >= 0.0);
constraint forall(i in I, t in T)(Cap[i,t] >= 0.0);
constraint forall(i in I, t in Tp)(X[i,t] >= 0.0);
constraint forall(i in I, t in Tp)(Inv[i,t] >= 0.0);

% Initial conditions (end of year 0)
constraint forall(i in I)(S[i,0] = Stock[i]);
constraint forall(i in I)(Cap[i,0] = Capacity[i]);

% Capacity evolution with 2-year lag for investment
% Cap[i,t] = Cap[i,0] + sum_{u=0..t-2} Inv[i,u]
constraint forall(i in I)(Cap[i,1] = Cap[i,0]);
constraint forall(i in I, t in 0..K-2)(
  Cap[i,t+2] = Cap[i,t+1] + Inv[i,t]
);

% Production limited by capacity in that year
constraint forall(i in I, t in Tp)(X[i,t] <= Cap[i,t]);

% Manpower limit each year (production + investment)
constraint forall(t in Tp)(
  sum(i in I)(ManpowerOne[i] * X[i,t] + ManpowerTwo[i] * Inv[i,t]) <= ManpowerLimit
);

% Goods balance with 1-year lag for using outputs:
% In year t (>=1): available = S[j,t-1] + X[j,t-1]
% uses: intermediate inputs for X[*,t], inputs for Inv[*,t], consumption Demand[j], remainder = S[j,t]
constraint forall(j in I)(
  S[j,1] =
      S[j,0] + X[j,0]
    - sum(i in I)(InputOne[j,i] * X[i,1])
    - sum(i in I)(InputTwo[j,i] * Inv[i,1])
    - Demand[j]
);

constraint forall(j in I, t in 2..K-1)(
  S[j,t] =
      S[j,t-1] + X[j,t-1]
    - sum(i in I)(InputOne[j,i] * X[i,t])
    - sum(i in I)(InputTwo[j,i] * Inv[i,t])
    - Demand[j]
);

% Terminal year K: no X[*,K] or Inv[*,K], only carry forward from year K-1 production and satisfy demand
constraint forall(j in I)(
  S[j,K] = S[j,K-1] + X[j,K-1] - Demand[j]
);

% -----------------------------
% Objective
% -----------------------------
solve maximize sum(i in I)(Cap[i,K]);