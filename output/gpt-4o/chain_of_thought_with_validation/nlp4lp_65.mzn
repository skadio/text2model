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
array[1..N] of var 0..1: c_isolate;
array[1..N] of var 0..1: c_scan;
array[1..N] of var 0..1: d_isolate;
array[1..N] of var 0..1: d_scan;

% Constraints
constraint
  forall(i in 1..N)(
      c_isolate[i] + c_scan[i] + d_isolate[i] + d_scan[i] = 1
  );

constraint
  sum(i in 1..N)(
      IsolateCentral[i] * c_isolate[i] +
      ScanCentral[i]    * c_scan[i]
  ) <= CentralMaxHours;

constraint
  sum(i in 1..N)(
      IsolateDistributed[i] * d_isolate[i] +
      ScanDistributed[i]    * d_scan[i]
  ) <= DistributedMaxHours;

% Objective
solve minimize
  sum(i in 1..N)(
      CentralCost    * (c_isolate[i] + c_scan[i]) +
      DistributedCost * (d_isolate[i] + d_scan[i])
  );