int: K;                                    % Number of industries
set of int: INDUSTRIES = 1..K;

int: Y = 5;                                % Planning horizon (years 0..Y)
set of int: YEARS              = 0..Y;
set of int: YEARS_BEFORE_LAST  = 0..Y-1;

/* Technical-coefficient data */
array[INDUSTRIES, INDUSTRIES] of float: InputOne;   % Inputs for next-year production
array[INDUSTRIES]              of float: ManpowerOne;

array[INDUSTRIES, INDUSTRIES] of float: InputTwo;   % Inputs for capacity building
array[INDUSTRIES]              of float: ManpowerTwo;

/* Initial stocks and capacities (year 0) */
array[INDUSTRIES] of float: Stock;
array[INDUSTRIES] of float: Capacity;

float: ManpowerLimit;                            % Yearly manpower limit
array[INDUSTRIES] of float: Demand;              % Exogenous consumption (years 1..Y)

float: BIG = 1.0e12;                             % Generic upper bound

/* Decision variables */
array[INDUSTRIES, YEARS] of var 0.0..BIG: prod;   % Output produced in year t
array[INDUSTRIES, YEARS] of var 0.0..BIG: inv;    % Investment outlays in year t
array[INDUSTRIES, YEARS] of var 0.0..BIG: stock;  % End-of-year inventories
array[INDUSTRIES, YEARS] of var 0.0..BIG: cap;    % Capacity available at start of year t

/* Initial conditions (year 0) */
constraint forall(i in INDUSTRIES)(
  cap[i,0] = Capacity[i]
);
constraint forall(i in INDUSTRIES)(
  stock[i,0] = Stock[i]
);

/* Capacity evolution: investment in year t boosts capacity from year t+2 on */
constraint
  forall(i in INDUSTRIES, t in 1..Y)(
    cap[i,t] = cap[i,t-1] + (if t >= 2 then inv[i,t-2] else 0.0 endif)
  );

/* Production limited by available capacity */
constraint
  forall(i in INDUSTRIES, t in YEARS)(
    prod[i,t] <= cap[i,t]
  );

/* Yearly manpower constraint */
constraint
  forall(t in YEARS)(
    sum(i in INDUSTRIES)(
      ManpowerOne[i] * prod[i,t] + ManpowerTwo[i] * inv[i,t]
    ) <= ManpowerLimit
  );

/* Material balance for years 0 .. Y-1 */
constraint
  forall(i in INDUSTRIES, t in YEARS_BEFORE_LAST)(
    prod[i,t] +
    (if t == 0 then Stock[i] else stock[i,t-1] endif) =
    (if t > 0 then Demand[i] else 0.0 endif) +
    sum(j in INDUSTRIES)( InputOne[i,j] * prod[j,t+1] ) +
    sum(j in INDUSTRIES)( InputTwo[i,j] * inv[j,t] ) +
    stock[i,t]
  );

/* Final-year balance (no further input requirements) */
constraint
  forall(i in INDUSTRIES)(
    prod[i,Y] + stock[i,Y-1] = Demand[i] + stock[i,Y]
  );

/* Objective: maximise total capacity at end of horizon */
solve maximize sum(i in INDUSTRIES)( cap[i,Y] );