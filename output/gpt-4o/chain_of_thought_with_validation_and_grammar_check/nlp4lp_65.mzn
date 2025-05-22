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
enum Type = {IsoC, ScanC, IsoD, ScanD};

array[1..N] of var Type: intervention_type;

var 0..CentralMaxHours: central_hours;
var 0..DistributedMaxHours: distributed_hours;

% Constraints
constraint
    central_hours =
        sum(i in 1..N)(
            bool2int(intervention_type[i] = IsoC) * IsolateCentral[i] +
            bool2int(intervention_type[i] = ScanC) * ScanCentral[i]
        );

constraint
    distributed_hours =
        sum(i in 1..N)(
            bool2int(intervention_type[i] = IsoD) * IsolateDistributed[i] +
            bool2int(intervention_type[i] = ScanD) * ScanDistributed[i]
        );

constraint
    central_hours <= CentralMaxHours;

constraint
    distributed_hours <= DistributedMaxHours;

% Objective
solve minimize CentralCost * central_hours + DistributedCost * distributed_hours;