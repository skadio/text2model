% Parameters
int: T;
int: K;

set of int: PERIOD = 1..T;
set of int: TYPE   = 1..K;

array[PERIOD] of int: Demand;
array[TYPE]   of int: NumGenerator;
array[TYPE]   of int: MinLevel;
array[TYPE]   of int: MaxLevel;
array[TYPE]   of int: RunCost;
array[TYPE]   of float: ExtraCost;
array[TYPE]   of int: StartCost;

% (Helpful derived constants)
int: MaxNumGenerator = max(NumGenerator);
int: MaxPower        = max([ MaxLevel[k] * NumGenerator[k] | k in TYPE ]);
float: MaxPowerF     = int2float(MaxPower);

% Variables
array[TYPE, PERIOD] of var 0..MaxNumGenerator: units_on;         % number of running units
array[TYPE, PERIOD] of var 0..MaxNumGenerator: units_start;      % units started in period
array[TYPE, PERIOD] of var 0.0..MaxPowerF:      power;           % total power produced

% Constraints
constraint
  % Production bounds for every type and period
  forall(k in TYPE, t in PERIOD)(
        power[k,t] >= int2float(units_on[k,t] * MinLevel[k])
    /\  power[k,t] <= int2float(units_on[k,t] * MaxLevel[k])
  );

constraint
  % Demand must be met exactly each period
  forall(t in PERIOD)(
        sum(k in TYPE)( power[k,t] ) = int2float(Demand[t])
  );

constraint
  % Units_on is limited by availability
  forall(k in TYPE, t in PERIOD)(
        units_on[k,t] <= NumGenerator[k]
  );

constraint
  % Start-up accounting
  forall(k in TYPE)(
        units_start[k,1] = units_on[k,1]
  );

constraint
  forall(k in TYPE, t in 2..T)(
        units_start[k,t] >= units_on[k,t] - units_on[k,t-1] /\
        units_start[k,t] <= units_on[k,t]                     % optional upper bound
  );

% Objective
solve minimize
  sum(k in TYPE, t in PERIOD)(
        int2float(RunCost[k] * units_on[k,t])                                   % running at minimum
      + ExtraCost[k] * ( power[k,t] - int2float(units_on[k,t] * MinLevel[k]) )  % extra production
      + int2float(StartCost[k] * units_start[k,t])                              % start-up cost
  );