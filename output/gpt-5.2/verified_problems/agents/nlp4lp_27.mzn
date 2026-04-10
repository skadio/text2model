% Parameters
int: K;  % Number of industries (also the dimension of coefficient arrays)

set of int: IND = 1..K;  % Industry index set

array[IND, IND] of float: InputOne;   % Intermediate input coeffs: goods j used in year t to produce output i in year t+1
array[IND] of float: ManpowerOne;     % Manpower per unit of output (production)

array[IND, IND] of float: InputTwo;   % Capacity build coeffs: investment goods j in year t add capacity to industry i in year t+2
array[IND] of float: ManpowerTwo;     % Manpower per unit of investment activity

array[IND] of float: Stock;           % Initial stock at end of year 0 (given)
array[IND] of float: Capacity;        % Initial capacity available in year 0 (given)

float: ManpowerLimit;                 % Annual manpower limit (constant across years)

array[IND] of float: Demand;          % Exogenous consumption requirement per year (years 1..T)


% Variables
int: T = 5;                           % Planning horizon length (fixed: five years)
set of int: Y0 = 0..T;                % Years including initial year 0
set of int: Y  = 1..T;                % Years with demand requirement

array[IND, Y0] of var float: prod;    % Production of industry i in year t
array[IND, Y0] of var float: invest;  % Output of industry i allocated to investment in year t

array[IND, Y0] of var float: stock;   % End-of-year stock of industry i in year t
array[IND, Y0] of var float: cap;     % Available productive capacity of industry i in year t

array[IND, Y0] of var float: cons;    % Consumption satisfied in year t (forced to Demand for t>=1)

var float: totalCapacityEnd;          % Total productive capacity at end of year T


% Constraints
%--------------------------
% Nonnegativity
%--------------------------
constraint forall(i in IND, t in Y0) (prod[i,t]  >= 0.0);
constraint forall(i in IND, t in Y0) (invest[i,t] >= 0.0);
constraint forall(i in IND, t in Y0) (stock[i,t] >= 0.0);
constraint forall(i in IND, t in Y0) (cap[i,t]   >= 0.0);
constraint forall(i in IND, t in Y0) (cons[i,t]  >= 0.0);

%--------------------------
% Initial conditions (year 0)
%--------------------------
constraint
  forall(i in IND) (
    stock[i,0] = Stock[i] /\
    cap[i,0]   = Capacity[i]
  );

% No exogenous consumption requirement in year 0
constraint forall(i in IND) (cons[i,0] = 0.0);

%--------------------------
% Consumption requirement (years 1..T)
%--------------------------
constraint forall(i in IND, t in Y) (cons[i,t] = Demand[i]);

%--------------------------
% Capacity limit on production (each year)
%--------------------------
constraint forall(i in IND, t in Y0) (prod[i,t] <= cap[i,t]);

%--------------------------
% Annual manpower limit (production + investment)
%--------------------------
constraint
  forall(t in Y0) (
    sum(i in IND) (ManpowerOne[i] * prod[i,t] + ManpowerTwo[i] * invest[i,t]) <= ManpowerLimit
  );

%--------------------------
% Goods balance with time lag on intermediate inputs
% For each industry j and year t=0..T-1:
%   prod[j,t] + stock[j,t] =
%     (inputs needed in year t to produce year t+1 output) + invest + cons + next stock
%--------------------------
constraint
  forall(j in IND, t in 0..T-1) (
    prod[j,t] + stock[j,t] =
      sum(i in IND) (InputOne[i,j] * prod[i,t+1]) +
      invest[j,t] +
      cons[j,t] +
      stock[j,t+1]
  );

%--------------------------
% Final year goods balance (t = T): no production supported beyond horizon and no stock beyond T
%--------------------------
constraint
  forall(j in IND) (
    prod[j,T] + stock[j,T] = invest[j,T] + cons[j,T]
  );

%--------------------------
% Capacity evolution with 2-year lag on investment
% No additions realized before year 2
%--------------------------
constraint forall(i in IND) (cap[i,1] = cap[i,0]);

% Capacity transition for years 2..T
constraint
  forall(i in IND, t in 2..T) (
    cap[i,t] = cap[i,t-1] + sum(j in IND) (InputTwo[i,j] * invest[j,t-2])
  );

%--------------------------
% Objective aggregation
%--------------------------
constraint totalCapacityEnd = sum(i in IND) (cap[i,T]);


% Objective
solve maximize totalCapacityEnd;