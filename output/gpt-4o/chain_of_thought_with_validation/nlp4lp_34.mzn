% -------------------------
% Parameters
% -------------------------
array[int] of int: Demand;           % electricity demand per period

int: K;                              % number of generator types

array[1..K] of int: NumGenerator;    % available units of each type
array[1..K] of int: MinLevel;        % minimum production of a unit (MW)
array[1..K] of int: MaxLevel;        % maximum production of a unit (MW)

array[1..K] of float: RunCost;       % cost for running one unit at MinLevel
array[1..K] of float: ExtraCost;     % cost per extra MW above MinLevel
array[1..K] of float: StartCost;     % start-up cost for one unit

% -------------------------
% Derived sets & constants
% -------------------------
set of int: PERIODS = index_set(Demand);
int: T = card(PERIODS);              % number of periods (deduced)

set of int: TYPES   = 1..K;

array[TYPES] of int: ExtraCap =
    [ MaxLevel[k] - MinLevel[k] | k in TYPES ];

int: maxNumGen    = max(NumGenerator);
int: maxExtraUnit = max(ExtraCap);
int: M_up         = maxNumGen * maxExtraUnit;   % upper bound for extra MW

% -------------------------
% Decision variables
% -------------------------
array[TYPES, PERIODS] of var 0..maxNumGen: x;     % units running
array[TYPES, PERIODS] of var 0..M_up     : up;    % MW above minimum
array[TYPES, PERIODS] of var 0..maxNumGen: start; % units started

% -------------------------
% Constraints
% -------------------------

% 1. Meet demand each period
constraint
  forall(t in PERIODS)(
    sum(k in TYPES)(
        MinLevel[k] * x[k,t] + up[k,t]
    ) >= Demand[t]
  );

% 2. Extra production limited by technical capability
constraint
  forall(k in TYPES, t in PERIODS)(
    up[k,t] <= ExtraCap[k] * x[k,t]
  );

% 3. Cannot run more units than available
constraint
  forall(k in TYPES, t in PERIODS)(
    x[k,t] <= NumGenerator[k]
  );

% 4. Start-up accounting
constraint
  forall(k in TYPES)(
    start[k,1] = x[k,1]
  )
  /\
  forall(k in TYPES, t in 2..T)(
    start[k,t] >= x[k,t] - x[k,t-1]
  );

% -------------------------
% Objective: minimise total cost
% -------------------------
var float: total_cost =
  sum(k in TYPES, t in PERIODS)(
        RunCost[k]  * int2float(x[k,t])
      + ExtraCost[k]* int2float(up[k,t])
      + StartCost[k]* int2float(start[k,t])
  );

solve minimize total_cost;