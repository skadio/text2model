% Parameters
int: K;                                             % Planning horizon (years)  & number of industries
set of int: INDUSTRIES = 1..K;                      % Industries / products
set of int: YEARS      = 0..K;                      % Years (0 = initial)

array[INDUSTRIES, INDUSTRIES] of float: InputOne;   % Type-1 input coefficients
array[INDUSTRIES]              of float: ManpowerOne;

array[INDUSTRIES, INDUSTRIES] of float: InputTwo;   % Type-2 input coefficients
array[INDUSTRIES]              of float: ManpowerTwo;

array[INDUSTRIES] of float: Stock;                  % Initial stocks (start of year 0)
array[INDUSTRIES] of float: Capacity;               % Annual production capacity
float: ManpowerLimit;                               % Yearly manpower limit


% Decision variables
array[YEARS, INDUSTRIES] of var 0.0..1.0e9: Prod;        % Production per industry & year
array[YEARS, INDUSTRIES] of var 0.0..1.0e9: StockLvl;    % Stock at START of year
array[YEARS, INDUSTRIES] of var 0.0..1.0e9: Demand;      % Input demand in each year


% 1. Initial stocks
constraint forall(i in INDUSTRIES)(
  StockLvl[0, i] = Stock[i]
);

% 2. No production in the initial year (no earlier inputs available)
constraint forall(i in INDUSTRIES)(
  Prod[0, i] = 0.0
);

% 3. Define input demand (t ≥ 1)
constraint
  forall(t in 1..K, j in INDUSTRIES)(
    Demand[t, j] =
      sum(k in INDUSTRIES)(
        (InputOne[j, k] + InputTwo[j, k]) * Prod[t, k]
      )
  );

% 4. Stock-flow balance
constraint
  forall(t in 0..K-1, j in INDUSTRIES)(
    StockLvl[t+1, j] = StockLvl[t, j] + Prod[t, j] - Demand[t+1, j]
  );

% 5. Non-negativity of stocks
constraint
  forall(t in YEARS, j in INDUSTRIES)(
    StockLvl[t, j] >= 0.0
  );

% 6. Capacity limits
constraint
  forall(t in YEARS, i in INDUSTRIES)(
    Prod[t, i] <= Capacity[i]
  );

% 7. Yearly manpower limit
constraint
  forall(t in YEARS)(
    sum(i in INDUSTRIES)(
      (ManpowerOne[i] + ManpowerTwo[i]) * Prod[t, i]
    ) <= ManpowerLimit
  );


% Objective: maximise production in the last two years
var float: TotalLastTwo =
  sum(i in INDUSTRIES)(
      Prod[K-1, i] +         % Penultimate year
      Prod[K  , i]           % Final year
  );

solve maximize TotalLastTwo;