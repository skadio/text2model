% Parameters
int: K;

array[1..K, 1..K] of float: InputOne;
array[1..K] of float: ManpowerOne;

array[1..K, 1..K] of float: InputTwo;
array[1..K] of float: ManpowerTwo;

array[1..K] of float: Stock;
array[1..K] of float: Capacity;

float: ManpowerLimit;

set of int: IND = 1..K;
set of int: Y = 0..K;

% Variables
array[IND, Y] of var float: prod;     % production in year t
array[IND, Y] of var float: invest;   % investment (used to build capacity) in year t
array[IND, Y] of var float: stockEnd; % end-of-year stock in year t
array[IND, Y] of var float: cap;      % productive capacity available in year t

% Constraints
% Nonnegativity
constraint forall(i in IND, t in Y) (prod[i,t] >= 0.0);
constraint forall(i in IND, t in Y) (invest[i,t] >= 0.0);
constraint forall(i in IND, t in Y) (stockEnd[i,t] >= 0.0);
constraint forall(i in IND, t in Y) (cap[i,t] >= 0.0);

% Initial conditions (year 0)
constraint forall(i in IND) (cap[i,0] = Capacity[i]);
constraint forall(i in IND) (stockEnd[i,0] = Stock[i]);

% No production/investment decisions beyond horizon for input-lag consistency
constraint forall(i in IND) (prod[i,K] = 0.0);
constraint forall(i in IND) (invest[i,K] = 0.0);

% Capacity limits (output in year t is limited by capacity available in year t)
constraint forall(i in IND, t in 0..K-1) (prod[i,t] <= cap[i,t]);

% Capacity evolution:
% investment in year t causes permanent increase available from year t+2
constraint forall(i in IND) (cap[i,1] = cap[i,0]);
constraint forall(i in IND, t in 2..K) (cap[i,t] = cap[i,t-1] + invest[i,t-2]);

% Goods balance with 1-year production input lag:
% In year t (>=1), production from all industries is allocated to:
% (a) intermediate inputs needed for production in year t+1
% (b) investment goods used to create capacity (available at t+2)
% (c) carryover stock to end of year t
constraint
  forall(i in IND, t in 1..K-1) (
    stockEnd[i,t-1] + prod[i,t]
    =
    stockEnd[i,t]
    + sum(j in IND) (InputOne[i,j] * prod[j,t+1] + InputTwo[i,j] * prod[j,t+1])
    + sum(j in IND) (InputOne[i,j] * invest[j,t] + InputTwo[i,j] * invest[j,t])
  );

% Terminal-year balance (no production beyond year K, so no intermediate demand for t=K)
constraint
  forall(i in IND) (
    stockEnd[i,K-1] + prod[i,K-1]
    =
    stockEnd[i,K]
    + sum(j in IND) (InputOne[i,j] * invest[j,K-1] + InputTwo[i,j] * invest[j,K-1])
  );

% Manpower constraint each year (applies to production and investment in that year)
constraint
  forall(t in 0..K-1) (
    sum(i in IND) (
      (ManpowerOne[i] + ManpowerTwo[i]) * (prod[i,t] + invest[i,t])
    ) <= ManpowerLimit
  );

% Objective
solve maximize sum(i in IND) (prod[i,K-2] + prod[i,K-1]);