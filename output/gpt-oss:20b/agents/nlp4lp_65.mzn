include "globals.mzn";

/*--- Data ---*/
int: N;
array[1..N] of int: IsolateCentral;
array[1..N] of int: ScanCentral;
array[1..N] of int: IsolateDistributed;
array[1..N] of int: ScanDistributed;
int: CentralCost;
int: DistributedCost;
int: CentralMaxHours;
int: DistributedMaxHours;

/*--- Decision variables ---*/
array[1..N] of var bool: useCentral;   % true = central, false = distributed
array[1..N] of var bool: useIsolate;   % true = isolate, false = scan

/*--- Derived time variables ---*/
array[1..N] of var int: timeCentral;
array[1..N] of var int: timeDistributed;

/*--- Link times to decisions ---*/
constraint forall(i in 1..N)(
    timeCentral[i] = bool2int(useCentral[i]) *
        ( bool2int(useIsolate[i]) * IsolateCentral[i]
        + (1 - bool2int(useIsolate[i])) * ScanCentral[i] )
);
constraint forall(i in 1..N)(
    timeDistributed[i] = bool2int(not useCentral[i]) *
        ( bool2int(useIsolate[i]) * IsolateDistributed[i]
        + (1 - bool2int(useIsolate[i])) * ScanDistributed[i] )
);

/*--- Resource limits ---*/
constraint sum(i in 1..N)(timeCentral[i])      <= CentralMaxHours;
constraint sum(i in 1..N)(timeDistributed[i]) <= DistributedMaxHours;

/*--- Objective: total cost ---*/
var int: totalCost;
constraint totalCost = sum(i in 1..N)(
    bool2int(useCentral[i]) * CentralCost
  + (1 - bool2int(useCentral[i])) * DistributedCost
);

solve minimize totalCost;

/*--- Output ---*/
output [
  "Total cost = ", show(totalCost), "\n",
  "Central hours used = ", show(sum(i in 1..N)(timeCentral[i])), "\n",
  "Distributed hours used = ", show(sum(i in 1..N)(timeDistributed[i])), "\n",
  "Interventions:\n",
  concat([ let {
      typeStr = if useIsolate[i] then "Isolate" else "Scan",
      procStr = if useCentral[i] then "Central" else "Distributed",
      time = if useCentral[i] then timeCentral[i] else timeDistributed[i]
    } in
      "  " ++ show(i) ++ ": " ++ typeStr ++ " via " ++ procStr ++
      " (time " ++ show(time) ++ ")\n"
  | i in 1..N ])
];