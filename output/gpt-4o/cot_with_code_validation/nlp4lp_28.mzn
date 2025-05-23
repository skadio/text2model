int: K;

set of int: INDUSTRIES = 1..K;
set of int: YEARS0     = 0..K;
set of int: YEARS      = 1..K;

/* Parameters */
array[INDUSTRIES, INDUSTRIES] of float: InputOne;
array[INDUSTRIES, INDUSTRIES] of float: InputTwo;

array[INDUSTRIES] of float: ManpowerOne;
array[INDUSTRIES] of float: ManpowerTwo;

array[INDUSTRIES] of float: Stock;
array[INDUSTRIES] of float: Capacity;

float: ManpowerLimit;

/* Decision variables */
array[INDUSTRIES, YEARS]  of var float: Prod;     % yearly production
array[INDUSTRIES, YEARS0] of var float: Invest;   % capacity-building investment
array[INDUSTRIES, YEARS0] of var float: CapVar;   % effective capacity

/* Non-negativity */
constraint forall(i in INDUSTRIES, t in YEARS)  ( Prod[i,t]   >= 0.0 );
constraint forall(i in INDUSTRIES, t in YEARS0) ( Invest[i,t] >= 0.0 );

/* Initial conditions */
constraint
  forall(i in INDUSTRIES)(
        CapVar[i,0] = Capacity[i] /\
        Invest[i,0] = 0.0
  );

/* Capacity evolution with two-year lag */
constraint
  forall(i in INDUSTRIES, t in YEARS)(
        CapVar[i,t] = CapVar[i,t-1] + ( if t >= 2 then Invest[i,t-2] else 0.0 endif )
  );

/* Production limited by capacity */
constraint
  forall(i in INDUSTRIES, t in YEARS)(
        Prod[i,t] <= CapVar[i,t]
  );

/* Yearly manpower limit */
constraint
  forall(t in YEARS)(
        sum(i in INDUSTRIES)(
              (ManpowerOne[i] + ManpowerTwo[i]) * (Prod[i,t] + Invest[i,t])
        ) <= ManpowerLimit
  );

/* Objective: maximise total production in the last two years */
var float: TotalLastTwo =
        sum(i in INDUSTRIES)(
              ( if K >= 2 then Prod[i,K-1] else 0.0 endif ) + Prod[i,K]
        );

solve maximize TotalLastTwo;