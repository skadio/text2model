int: K;
int: T = 5;                         % planning horizon: years 0 … 5
set of int: Years       = 0..T;     % indices for production / capacity / build
set of int: StockYears  = 0..T+1;   % indices for stocks (need year 6 to absorb year-5 demand)

array[1..K,1..K] of float: InputOne;
array[1..K]       of float: ManpowerOne;
array[1..K,1..K] of float: InputTwo;
array[1..K]       of float: ManpowerTwo;
array[1..K]       of float: Stock;        % initial stocks (year 0)
array[1..K]       of float: Capacity;     % initial productive capacities (year 0)
float: ManpowerLimit;
array[1..K]       of float: Demand;       % exogenous yearly demand (years 1 … 5)

% Decision variables
array[1..K,Years]      of var 0.0..1e12: prod;   % production of each industry, each year
array[1..K,Years]      of var 0.0..1e12: build;  % capacity-building activity (decided in year t)
array[1..K,StockYears] of var 0.0..1e12: stock;  % stock at the start of each year
array[1..K,Years]      of var 0.0..1e12: cap;    % productive capacity at the start of each year

% Initial conditions
constraint forall(i in 1..K)(
    stock[i,0] = Stock[i] /\
    cap[i,0]   = Capacity[i]
);

% Capacity evolution with two-year lag
constraint
    forall(i in 1..K, t in 1..T)(
        cap[i,t] = cap[i,t-1] + (if t >= 2 then build[i,t-2] else 0.0 endif)
);

% Production cannot exceed available capacity
constraint
    forall(i in 1..K, t in Years)(
        prod[i,t] <= cap[i,t]
);

% Stock balance and non-negativity
constraint
    forall(j in 1..K, t in Years)(
        stock[j,t+1] = stock[j,t]
                       - sum(i in 1..K)(InputOne[i,j] * prod[i,t])
                       - sum(i in 1..K)(InputTwo[i,j] * build[i,t])
                       - (if t == 0 then 0.0 else Demand[j] endif)
                       + prod[j,t]
    )
    /\ forall(j in 1..K, s in StockYears)( stock[j,s] >= 0.0 );

% Yearly manpower limit
constraint
    forall(t in Years)(
        sum(i in 1..K)(
            ManpowerOne[i] * prod[i,t] +
            ManpowerTwo[i] * build[i,t]
        ) <= ManpowerLimit
);

% Objective: maximise total productive capacity at the end of year 5
solve maximize
    sum(i in 1..K)( cap[i,T] );