% Parameters
int: N;
array[1..N] of int: IsolateCentral;
array[1..N] of int: ScanCentral;
array[1..N] of int: IsolateDistributed;
array[1..N] of int: ScanDistributed;
int: CentralCost;
int: DistributedCost;
int: CentralMaxHours;
int: DistributedMaxHours;

% Variables
array[1..N] of var 0..1: isolate_central;
array[1..N] of var 0..1: scan_central;
array[1..N] of var 0..1: isolate_distributed;
array[1..N] of var 0..1: scan_distributed;

var 0..CentralMaxHours: total_central_hours;
var 0..DistributedMaxHours: total_distributed_hours;
var int: total_cost;

% Constraints
constraint
    forall(i in 1..N) (
        isolate_central[i] + scan_central[i] +
        isolate_distributed[i] + scan_distributed[i] = 1
    );

constraint
    total_central_hours = sum(i in 1..N)(
        IsolateCentral[i] * isolate_central[i] +
        ScanCentral[i]    * scan_central[i]
    );

constraint
    total_distributed_hours = sum(i in 1..N)(
        IsolateDistributed[i] * isolate_distributed[i] +
        ScanDistributed[i]    * scan_distributed[i]
    );

constraint total_central_hours <= CentralMaxHours;
constraint total_distributed_hours <= DistributedMaxHours;

constraint
    total_cost = CentralCost * total_central_hours +
                 DistributedCost * total_distributed_hours;

% Objective
solve minimize total_cost;