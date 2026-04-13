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
% intervention[i] = 1 => isolate, 2 => scan
array[I] of var 1..2: InterventionType;

% processing[i] = 1 => central, 2 => distributed
array[I] of var 1..2: ProcessingType;

% Derived per-intervention time based on chosen intervention and processing type
array[I] of var int: ProcTime =
[
  if ProcessingType[i] = 1 then
    (if InterventionType[i] = 1 then IsolateCentral[i] else ScanCentral[i] endif)
  else
    (if InterventionType[i] = 1 then IsolateDistributed[i] else ScanDistributed[i] endif)
  endif
  | i in I
];

% Capacity constraints (total hours by processing type)
constraint
  sum(i in I)(ProcTime[i] * bool2int(ProcessingType[i] = 1)) <= CentralMaxHours;

constraint
  sum(i in I)(ProcTime[i] * bool2int(ProcessingType[i] = 2)) <= DistributedMaxHours;

% Objective: minimize total opportunity cost by processing type
var int: TotalCost =
  sum(i in I)(
    CentralCost * bool2int(ProcessingType[i] = 1) +
    DistributedCost * bool2int(ProcessingType[i] = 2)
  );

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "InterventionType (1=isolate,2=scan)=", show(InterventionType), "\n",
  "ProcessingType (1=central,2=distributed)=", show(ProcessingType), "\n",
  "ProcTime=", show(ProcTime), "\n",
  "CentralHours=", show(sum(i in I)(ProcTime[i] * bool2int(ProcessingType[i] = 1))), "\n",
  "DistributedHours=", show(sum(i in I)(ProcTime[i] * bool2int(ProcessingType[i] = 2))), "\n"
];