% Intervention scheduling to halt an intrusion in a network

% Data declarations (to be provided via a .dzn file)
int: N;
array[1..N] of int: IsolateCentral;
array[1..N] of int: ScanCentral;
array[1..N] of int: IsolateDistributed;
array[1..N] of int: ScanDistributed;
int: CentralCost;
int: DistributedCost;
int: CentralMaxHours;
int: DistributedMaxHours;

% Decision variables:
% interventionType[i] = 1 means "Isolate"; 2 means "Scan".
array[1..N] of var 1..2: interventionType;
% processingMethod[i] = 1 means "Central"; 2 means "Distributed".
array[1..N] of var 1..2: processingMethod;

% Calculate the total processing time on the central system.
var 0..sum(IsolateCentral)+sum(ScanCentral): totalCentralTime = 
  sum(i in 1..N)(
    if processingMethod[i] = 1 then 
      if interventionType[i] = 1 then IsolateCentral[i] else ScanCentral[i]
      endif
    else 0
    endif
  );

% Calculate the total processing time on the distributed system.
var 0..sum(IsolateDistributed)+sum(ScanDistributed): totalDistributedTime = 
  sum(i in 1..N)(
    if processingMethod[i] = 2 then 
      if interventionType[i] = 1 then IsolateDistributed[i] else ScanDistributed[i]
      endif
    else 0
    endif
  );

% Resource (processing hour) capacity constraints.
constraint totalCentralTime <= CentralMaxHours;
constraint totalDistributedTime <= DistributedMaxHours;

% Objective: Minimize the total cost
var int: totalCost = sum(i in 1..N)(
  if processingMethod[i] = 1 then CentralCost else DistributedCost endif
);
solve minimize totalCost;

% Output the chosen intervention types and processing methods, plus totals.
output [
  "Total Cost = ", show(totalCost), "\n",
  "Total Central Time = ", show(totalCentralTime), "\n",
  "Total Distributed Time = ", show(totalDistributedTime), "\n",
  "Intervention Decisions:\n"] 
  ++ [ 
      "Intervention ", show(i), ": " 
      ++ (if interventionType[i] = 1 then "Isolate" else "Scan" endif) 
      ++ " via " ++ (if processingMethod[i] = 1 then "Central" else "Distributed" endif) ++ "\n"
      | i in 1..N
     ];