int: T;                                    % Total number of periods (may be ignored)
int: K;                                    % Total number of generator types (may be ignored)

array[int] of int: Demand;                 % Electricity demand in each period
set of int: PERIODS = index_set(Demand);

array[int] of int: NumGenerator;           % Available units of each type
set of int: TYPES = index_set(NumGenerator);

array[TYPES] of int: MinLevel;             % Minimum production level of one unit of type k
array[TYPES] of int: MaxLevel;             % Maximum production level of one unit of type k
array[TYPES] of int: RunCost;              % Fixed running cost per unit (per period) of type k
array[TYPES] of float: ExtraCost;          % Variable cost per MW above MinLevel for type k
array[TYPES] of int: StartCost;            % Start-up cost per unit of type k

array[TYPES] of int: ExtraPerUnit = array1d(TYPES,
    [ MaxLevel[k] - MinLevel[k] | k in TYPES ]);
array[TYPES] of int: MaxExtraCap = array1d(TYPES,
    [ ExtraPerUnit[k] * NumGenerator[k] | k in TYPES ]);

int: MaxUnits = max([ NumGenerator[k] | k in TYPES ]);
int: MaxExtra = max([ MaxExtraCap[k]  | k in TYPES ]);

array[PERIODS, TYPES] of var 0..MaxUnits: unitsOn;      % #units of type k running in period t
array[PERIODS, TYPES] of var 0..MaxUnits: unitsStart;   % #units of type k started in period t
array[PERIODS, TYPES] of var 0..MaxExtra: extraProd;    % Additional MW above MinLevel for type k in period t

% 1. Availability limits
constraint
  forall(t in PERIODS, k in TYPES)(
        unitsOn[t,k] <= NumGenerator[k]
  );

% 2. Start-up relations
constraint
  forall(k in TYPES)(
        unitsStart[min(PERIODS),k] = unitsOn[min(PERIODS),k]
  );
constraint
  forall(t in 2..max(PERIODS), k in TYPES)(
        unitsStart[t,k] >= unitsOn[t,k] - unitsOn[t-1,k] /\
        unitsStart[t,k] <= unitsOn[t,k]                 /\
        unitsStart[t,k] <= NumGenerator[k] - unitsOn[t-1,k]
  );

% 3. Extra production bounds
constraint
  forall(t in PERIODS, k in TYPES)(
        extraProd[t,k] <= ExtraPerUnit[k] * unitsOn[t,k]
  );

% 4. Demand satisfaction
constraint
  forall(t in PERIODS)(
        sum(k in TYPES)(
            unitsOn[t,k] * MinLevel[k] + extraProd[t,k]
        ) >= Demand[t]
  );

% Objective: minimise total cost
var float: totalCost =
      % Running cost at minimum output
      sum(t in PERIODS, k in TYPES)(
          int2float(RunCost[k] * unitsOn[t,k])
      )
    + % Extra production cost
      sum(t in PERIODS, k in TYPES)(
          ExtraCost[k] * int2float(extraProd[t,k])
      )
    + % Start-up cost
      sum(t in PERIODS, k in TYPES)(
          int2float(StartCost[k] * unitsStart[t,k])
      );

solve minimize totalCost;