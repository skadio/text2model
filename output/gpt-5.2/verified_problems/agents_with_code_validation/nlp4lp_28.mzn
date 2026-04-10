% Use a solver/backend that supports LP/MIP style float arithmetic
% (avoids Gecode float linear limitations)
solve maximize 0.0;

% Parameters
int: K;                                   % Number of industries (and planning years index length)
set of int: I = 1..K;                     % Industry index set
set of int: T = 0..K;                     % Year index set

array[I, I] of float: InputOne;           % Input coefficients type 1: from i to produce 1 unit of j
array[I] of float: ManpowerOne;           % Manpower per unit for industry i (type 1)
array[I, I] of float: InputTwo;           % Input coefficients type 2: from i to produce 1 unit of j
array[I] of float: ManpowerTwo;           % Manpower per unit for industry i (type 2)

array[I] of float: Stock;                 % Initial stocks at start of year 0
array[I] of float: Capacity;              % Initial production capacity in year 0

float: ManpowerLimit;                     % Total manpower available per year

% Combined coefficients
array[I,I] of float: Input = array2d(I,I,[ InputOne[i,j] + InputTwo[i,j] | i in I, j in I ]);
array[I] of float: Manpower = [ ManpowerOne[i] + ManpowerTwo[i] | i in I ];

% Variables (all nonnegative)
array[T, I] of var float: production;      % Production in year t of industry i
array[T, I] of var float: inventory;       % End-of-year inventory in year t for industry i
array[T, I] of var float: capacityAvail;   % Capacity available in year t for industry i
array[T, I] of var float: capIncrease;     % Capacity increase initiated in year t for industry i (available in t+2)
array[T, I] of var float: investUse;       % Output of industry i used in year t for investment
array[T] of var float: manpowerUsed;       % Total manpower used in year t

constraint forall(t in T, i in I) (
  production[t,i] >= 0.0 /\
  inventory[t,i]  >= 0.0 /\
  capacityAvail[t,i] >= 0.0 /\
  capIncrease[t,i] >= 0.0 /\
  investUse[t,i] >= 0.0
);

% Initial conditions (year 0)
constraint forall(i in I) (
  inventory[0,i] = Stock[i] /\
  capacityAvail[0,i] = Capacity[i]
);

% Capacity availability and expansions
constraint forall(i in I) (
  capacityAvail[1,i] = capacityAvail[0,i]
);

constraint forall(t in 0..K-2, i in I) (
  capacityAvail[t+2,i] = capacityAvail[t+1,i] + capIncrease[t,i]
);

% Production bounded by available capacity
constraint forall(t in T, i in I) (
  production[t,i] <= capacityAvail[t,i]
);

% Inventory balance (t=0 separately to avoid self-reference)
constraint forall(i in I) (
  inventory[0,i] =
      Stock[i] + production[0,i]
      - investUse[0,i]
      - sum(j in I)( Input[i,j] * production[1,j] )
);

constraint forall(t in 1..K-1, i in I) (
  inventory[t,i] =
      inventory[t-1,i] + production[t,i]
      - investUse[t,i]
      - sum(j in I)( Input[i,j] * production[t+1,j] )
);

constraint forall(i in I) (
  inventory[K,i] =
      inventory[K-1,i] + production[K,i]
      - investUse[K,i]
);

% Feasibility of investment use (cannot exceed goods available that year)
constraint forall(i in I) (
  investUse[0,i] <= Stock[i] + production[0,i]
);
constraint forall(t in 1..K, i in I) (
  investUse[t,i] <= inventory[t-1,i] + production[t,i]
);

% Manpower accounting and yearly limit
constraint forall(t in T) (
  manpowerUsed[t] =
    sum(i in I)( Manpower[i] * production[t,i] + Manpower[i] * capIncrease[t,i] )
);

constraint forall(t in T) (
  manpowerUsed[t] <= ManpowerLimit
);

% Objective: maximize total production in last two years (K-1 and K)
solve maximize sum(i in I)(production[K-1,i] + production[K,i]);