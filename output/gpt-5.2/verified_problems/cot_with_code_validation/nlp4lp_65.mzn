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

% Decision variables
array[I] of var bool: doIsolate;   % true = isolate, false = scan
array[I] of var bool: useCentral;  % true = central, false = distributed

% Derived times (in hours) for each intervention on each platform
array[I] of var int: timeCentral;
array[I] of var int: timeDistributed;

var int: totalCentralHours;
var int: totalDistributedHours;
var int: totalCost;

% Constraints: compute platform-specific times (0 if not chosen)
constraint forall(i in I) (
  timeCentral[i] =
    bool2int(useCentral[i]) *
    ( bool2int(doIsolate[i]) * IsolateCentral[i]
    + bool2int(not doIsolate[i]) * ScanCentral[i] )
);

constraint forall(i in I) (
  timeDistributed[i] =
    bool2int(not useCentral[i]) *
    ( bool2int(doIsolate[i]) * IsolateDistributed[i]
    + bool2int(not doIsolate[i]) * ScanDistributed[i] )
);

% Total hours
constraint totalCentralHours = sum(i in I)(timeCentral[i]);
constraint totalDistributedHours = sum(i in I)(timeDistributed[i]);

% Capacity limits
constraint totalCentralHours <= CentralMaxHours;
constraint totalDistributedHours <= DistributedMaxHours;

% Total opportunity cost: per intervention, depending on chosen platform
constraint totalCost =
  sum(i in I)(
    bool2int(useCentral[i]) * CentralCost +
    bool2int(not useCentral[i]) * DistributedCost
  );

% Objective
solve minimize totalCost;

% Output (optional but useful)
output [
  "totalCost=", show(totalCost), "\n",
  "totalCentralHours=", show(totalCentralHours), "\n",
  "totalDistributedHours=", show(totalDistributedHours), "\n",
  "doIsolate=", show(doIsolate), "\n",
  "useCentral=", show(useCentral), "\n"
];