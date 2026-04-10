% Parameters
int: N;
set of int: I = 1..N;

array[I] of int: IsolateCentral;
array[I] of int: ScanCentral;
array[I] of int: IsolateDistributed;
array[I] of int: ScanDistributed;

int: CentralCost;
int: DistributedCost;
int: CentralMaxHours;
int: DistributedMaxHours;

% Variables
% choice of intervention per cluster: isolate (true) or scan (false)
array[I] of var bool: doIsolate;

% processing mode per cluster: central (true) or distributed (false)
array[I] of var bool: useCentral;

array[I] of var int: timeCentral;
array[I] of var int: timeDistributed;

var int: totalCost;

% Constraints
constraint forall(i in I) (
  timeCentral[i] >= 0 /\ timeDistributed[i] >= 0
);

constraint forall(i in I) (
  timeCentral[i] =
    bool2int(useCentral[i]) *
    ( bool2int(doIsolate[i]) * IsolateCentral[i]
    + (1 - bool2int(doIsolate[i])) * ScanCentral[i]
    )
);

constraint forall(i in I) (
  timeDistributed[i] =
    (1 - bool2int(useCentral[i])) *
    ( bool2int(doIsolate[i]) * IsolateDistributed[i]
    + (1 - bool2int(doIsolate[i])) * ScanDistributed[i]
    )
);

constraint sum(i in I)(timeCentral[i]) <= CentralMaxHours;
constraint sum(i in I)(timeDistributed[i]) <= DistributedMaxHours;

constraint totalCost =
  CentralCost * sum(i in I)(bool2int(useCentral[i])) +
  DistributedCost * sum(i in I)(1 - bool2int(useCentral[i]));

% Objective
solve minimize totalCost;