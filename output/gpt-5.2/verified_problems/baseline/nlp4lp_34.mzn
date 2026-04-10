% Unit Commitment / Generator Scheduling
% Data expected in .dzn with names:
% T, K, Demand[1..T], NumGenerator[1..K], MinLevel[1..K], MaxLevel[1..K],
% RunCost[1..K], ExtraCost[1..K], StartCost[1..K]

int: T;
int: K;

array[1..T] of int: Demand;

array[1..K] of int: NumGenerator;
array[1..K] of int: MinLevel;
array[1..K] of int: MaxLevel;

array[1..K] of int: RunCost;
array[1..K] of float: ExtraCost;
array[1..K] of int: StartCost;

set of int: PERIODS = 1..T;
set of int: TYPES   = 1..K;

% Number of units of type k online in period t
array[TYPES, PERIODS] of var 0..max(NumGenerator): On;

% Total MW produced by type k in period t
int: BigM = max([NumGenerator[k] * MaxLevel[k] | k in TYPES]);
array[TYPES, PERIODS] of var 0..BigM: Prod;

% Number of start-ups of type k at start of period t (compared to previous period)
array[TYPES, PERIODS] of var 0..max(NumGenerator): Start;

% Capacity bounds linked to commitment
constraint
  forall(k in TYPES, t in PERIODS) (
    Prod[k,t] >= On[k,t] * MinLevel[k] /\
    Prod[k,t] <= On[k,t] * MaxLevel[k]
  );

% Demand satisfaction (can overgenerate if desired; here force exact meeting)
constraint
  forall(t in PERIODS) (
    sum(k in TYPES)(Prod[k,t]) = Demand[t]
  );

% Start-ups: count increases in On from previous period (initially 0 online)
constraint
  forall(k in TYPES, t in PERIODS) (
    Start[k,t] >= On[k,t] - (if t = 1 then 0 else On[k,t-1] endif) /\
    Start[k,t] >= 0
  );

% Cost computation
array[TYPES, PERIODS] of var float: PeriodCost;

constraint
  forall(k in TYPES, t in PERIODS) (
    PeriodCost[k,t] =
      float(RunCost[k]) * float(On[k,t]) +
      ExtraCost[k] * ( float(Prod[k,t]) - float(MinLevel[k]) * float(On[k,t]) ) +
      float(StartCost[k]) * float(Start[k,t])
  );

var float: TotalCost = sum(k in TYPES, t in PERIODS)(PeriodCost[k,t]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "On (units online) by type and period:\n"
] ++
[
  "Type ", show(k), ": ", show([On[k,t] | t in PERIODS]), "\n"
  | k in TYPES
] ++
[
  "Prod (MW) by type and period:\n"
] ++
[
  "Type ", show(k), ": ", show([Prod[k,t] | t in PERIODS]), "\n"
  | k in TYPES
] ++
[
  "Start (units started) by type and period:\n"
] ++
[
  "Type ", show(k), ": ", show([Start[k,t] | t in PERIODS]), "\n"
  | k in TYPES
];