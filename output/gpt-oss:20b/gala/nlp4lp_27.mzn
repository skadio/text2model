include "globals.mzn";

% --------------------
% Parameters (from data file)
% --------------------
int: K;                                   % number of industries

array[1..K] of float: InitialCapacity;    % capacity at year 0
array[1..K] of float: InitialStock;       % stock at year 0

array[1..K, 1..K] of float: InputOne;     % input‑one coefficients
array[1..K, 1..K] of float: InputTwo;     % input‑two coefficients

array[1..K] of float: ManpowerOne;        % manpower coefficient – part 1
array[1..K] of float: ManpowerTwo;        % manpower coefficient – part 2

float: ManpowerLimit;                     % total manpower available each year

array[1..K] of float: Demand;             % yearly demand for each industry

% --------------------
% Decision variables
% --------------------
int: Y = 5;                               % planning horizon in years

array[1..K, 1..Y] of var float: prod;     % production of industry i in year t
array[1..K, 1..Y] of var float: cap;      % productive capacity in year t
array[1..K, 1..Y] of var float: stock;    % stock at the start of year t

% --------------------
% Initial conditions
% --------------------
constraint forall(i in 1..K)(
    cap[i,1] = InitialCapacity[i]
    /\ stock[i,1] = InitialStock[i]
);

% Capacity in year 2 is the same as in year 1 (no immediate increase)
constraint forall(i in 1..K)(
    cap[i,2] = cap[i,1]
);

% Production cannot exceed current capacity
constraint forall(i in 1..K, t in 1..Y)(
    prod[i,t] <= cap[i,t]
);

% --------------------
% Input consumption
% --------------------
constraint forall(j in 1..K, t in 1..Y)(
    stock[j,t] >=
        sum(i in 1..K) ( (InputOne[i,j] + InputTwo[i,j]) * prod[i,t] )
);

% --------------------
% Stock evolution
% --------------------
constraint forall(j in 1..K, t in 1..Y-1)(
    stock[j,t+1] =
        stock[j,t]
        - sum(i in 1..K) ( (InputOne[i,j] + InputTwo[i,j]) * prod[i,t] )
        + prod[j,t]      % output of industry j added to its own stock
);

% --------------------
% Capacity evolution (increase 2 years after inputs)
% --------------------
constraint forall(j in 1..K, t in 1..Y-2)(
    cap[j,t+2] =
        cap[j,t+1]
        + sum(i in 1..K) ( (InputOne[i,j] + InputTwo[i,j]) * prod[i,t] )
);

% --------------------
% Demand satisfaction for years >1
% --------------------
constraint forall(i in 1..K, t in 2..Y)(
    stock[i,t] >= Demand[i]
);

% --------------------
% Manpower constraint each year
% --------------------
constraint forall(t in 1..Y)(
    sum(i in 1..K) ( (ManpowerOne[i] + ManpowerTwo[i]) * prod[i,t] )
    <= ManpowerLimit
);

% --------------------
% Objective: maximise total capacity at the end of year Y
% --------------------
solve maximize sum(i in 1..K) cap[i,Y];

% --------------------
% Output
% --------------------
output [
    "Production by industry:\n",
    concat([ show(i) ++ ": " ++ show([ prod[i,t] | t in 1..Y ]) ++ "\n" | i in 1..K ]),
    "Capacity at year " ++ show(Y) ++ ": " ++ show([ cap[i,Y] | i in 1..K ]) ++ "\n",
    "Stock at year " ++ show(Y) ++ ": " ++ show([ stock[i,Y] | i in 1..K ]) ++ "\n"
];