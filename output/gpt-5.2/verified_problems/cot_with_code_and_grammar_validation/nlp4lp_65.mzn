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
array[1..N] of var 0..1: useCentral;        % 1 if cluster/intervention handled centrally, else distributed
array[1..N] of var 0..1: doIsolate;         % 1 isolate, 0 scan (exactly one chosen)

% Auxiliary time variables to keep linearity explicit
int: maxTime =
    max([IsolateCentral[i] | i in 1..N] ++ [ScanCentral[i] | i in 1..N] ++
        [IsolateDistributed[i] | i in 1..N] ++ [ScanDistributed[i] | i in 1..N]);

array[1..N] of var 0..maxTime: timeCentral_i;
array[1..N] of var 0..maxTime: timeDistributed_i;

% Constraints
constraint forall(i in 1..N) (
    % Central time if assigned centrally, depends on isolate/scan choice
    timeCentral_i[i] =
        useCentral[i] * (doIsolate[i] * IsolateCentral[i] + (1 - doIsolate[i]) * ScanCentral[i])
);

constraint forall(i in 1..N) (
    % Distributed time if assigned distributed, depends on isolate/scan choice
    timeDistributed_i[i] =
        (1 - useCentral[i]) * (doIsolate[i] * IsolateDistributed[i] + (1 - doIsolate[i]) * ScanDistributed[i])
);

constraint sum(i in 1..N)(timeCentral_i[i]) <= CentralMaxHours;
constraint sum(i in 1..N)(timeDistributed_i[i]) <= DistributedMaxHours;

% Objective
solve minimize
    sum(i in 1..N)(useCentral[i] * CentralCost + (1 - useCentral[i]) * DistributedCost);