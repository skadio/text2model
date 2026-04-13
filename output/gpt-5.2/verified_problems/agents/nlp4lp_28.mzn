% Parameters
int: K;  % number of industries (also used as the index range in the provided data)

set of int: IND = 1..K;  % industry/product index set

array[IND, IND] of float: InputOne;     % input coefficient from industry i to produce 1 unit of industry j
array[IND] of float:      ManpowerOne;  % manpower per unit output for industry j (type one)

array[IND, IND] of float: InputTwo;     % input coefficient from industry i to produce 1 unit of industry j
array[IND] of float:      ManpowerTwo;  % manpower per unit output for industry j (type two)

array[IND] of float: Stock;     % initial stock of each industry/product at start (year 0)
array[IND] of float: Capacity;  % initial production capacity of each industry/product at year 0

float: ManpowerLimit;  % total available manpower per year (fixed)


% Variables
array[0..K, IND] of var float: production;    % production in year t of industry i (>= 0), t=0..K
array[0..K, IND] of var float: inventory;     % end-of-year inventory/stock in year t of industry i (>= 0), t=0..K

array[0..K, IND] of var float: capacityAvail; % available capacity in year t for industry i (>= 0), t=0..K

array[0..K, IND, IND] of var float: investFlow;
% investFlow[t,i,j] = amount of industry i output used in year t to build capacity of industry j (>= 0)

array[0..K, IND] of var float: manpowerUsed;  % manpower used in year t by industry i (>= 0), t=0..K

var float: totalProductionLastTwoYears;       % objective value: total production in years K-1 and K


% Constraints

%-----------------------------
% Non-negativity (safety)
%-----------------------------
constraint
  forall(t in 0..K, i in IND) (
    production[t,i] >= 0.0 /\
    inventory[t,i]  >= 0.0 /\
    capacityAvail[t,i] >= 0.0 /\
    manpowerUsed[t,i] >= 0.0
  );

constraint
  forall(t in 0..K, i in IND, j in IND) (
    investFlow[t,i,j] >= 0.0
  );

%-----------------------------
% Initial conditions (year 0)
%-----------------------------
constraint
  forall(i in IND) (
    inventory[0,i] = Stock[i]
  );

constraint
  forall(i in IND) (
    capacityAvail[0,i] = Capacity[i]
  );

%-----------------------------
% Manpower accounting + yearly limit
% manpower used in year t is proportional to that year's production
%-----------------------------
constraint
  forall(t in 0..K, j in IND) (
    manpowerUsed[t,j] = (ManpowerOne[j] + ManpowerTwo[j]) * production[t,j]
  );

constraint
  forall(t in 0..K) (
    sum(j in IND)(manpowerUsed[t,j]) <= ManpowerLimit
  );

%-----------------------------
% Capacity limits on production (each year)
%-----------------------------
constraint
  forall(t in 0..K, i in IND) (
    production[t,i] <= capacityAvail[t,i]
  );

%-----------------------------
% Material balance (inventory evolution with 1-year input lag)
% In year t, output produced plus prior inventory is allocated to:
%  - intermediate inputs needed for production in year t+1 (if t < K)
%  - investment uses in year t (investFlow[t, i, *])
%  - ending inventory
%-----------------------------
constraint
  forall(t in 0..K, i in IND) (
    inventory[t,i] =
      (if t = 0 then Stock[i] else inventory[t-1,i] endif)
      + production[t,i]
      - sum(j in IND)(
          (if t < K then (InputOne[i,j] + InputTwo[i,j]) * production[t+1,j] else 0.0 endif)
        )
      - sum(j in IND)(investFlow[t,i,j])
  );

%-----------------------------
% Capacity accumulation with 2-year investment lag
% Investment in year t increases capacity permanently starting year t+2.
% Interpreting investFlow[t, i, j] as the amount of industry i goods used to
% create capacity for industry j; 1 unit of capacity of j requires 1 unit of goods
% from each industry i (bottlenecked by the minimum across i).
%-----------------------------
constraint
  forall(t in 0..K, j in IND) (
    capacityAvail[t,j] =
      Capacity[j] +
      sum(u in 0..K where u + 2 <= t)(
        min(i in IND)(investFlow[u,i,j])
      )
  );

%-----------------------------
% Total production in the last two years (definition only; no objective here)
%-----------------------------
constraint
  totalProductionLastTwoYears =
    sum(i in IND)(
      (if K-1 >= 0 then production[K-1,i] else 0.0 endif) + production[K,i]
    );


% Objective
solve maximize totalProductionLastTwoYears;