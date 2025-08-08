int: N;
array[1..N] of int: IsolateCentral;
array[1..N] of int: ScanCentral;
array[1..N] of int: IsolateDistributed;
array[1..N] of int: ScanDistributed;
int: CentralCost;
int: DistributedCost;
int: CentralMaxHours;
int: DistributedMaxHours;

array[1..N] of var 0..1: type; % 0 = Isolate, 1 = Scan
array[1..N] of var 0..1: mode; % 0 = Central, 1 = Distributed

constraint
  sum(i in 1..N) (
    if mode[i] == 0 then
      if type[i] == 0 then IsolateCentral[i] else ScanCentral[i]
    else 0
  ) <= CentralMaxHours;

constraint
  sum(i in 1..N) (
    if mode[i] == 1 then
      if type[i] == 0 then IsolateDistributed[i] else ScanDistributed[i]
    else 0
  ) <= DistributedMaxHours;

solve minimize
  sum(i in 1..N) (
    if mode[i] == 0 then CentralCost else DistributedCost
  );

output [
  "Total Cost: " ++ show(sum(i in 1..N) (if mode[i]==0 then CentralCost else DistributedCost)) ++ "\n",
  "Central Time: " ++ show(sum(i in 1..N) (if mode[i]==0 then (if type[i]==0 then IsolateCentral[i] else ScanCentral[i]) else 0)) ++ "\n",
  "Distributed Time: " ++ show(sum(i in 1..N) (if mode[i]==1 then (if type[i]==0 then IsolateDistributed[i] else ScanDistributed[i]) else 0)) ++ "\n",
  "Assignments:\n",
  concat([ "Intervention " ++ show(i) ++ ": " ++ (if type[i]==0 then "Isolate" else "Scan") ++ ", " ++ (if mode[i]==0 then "Central" else "Distributed") ++ "\n" | i in 1..N ])
];