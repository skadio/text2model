% Parameters
int: N;
set of int: SYS = 1..N;

array[SYS] of bool: IsWorkstation;
array[SYS] of int: Price;
array[SYS] of float: DiskDrives;
array[SYS] of int: MemoryBoards;

int: MaxCpu;

int: MinDisk;
int: MaxDisk;

int: MinMemory;
int: MaxMemory;

array[SYS] of int: Demand;
int: DemandGP;
int: DemandWS;

array[SYS] of int: Preorder;

int: AltMemory;
array[SYS] of bool: AltCompatible;

% Variables
array[SYS] of var float: Prod;
array[SYS] of var float: AltUsed;
array[SYS] of var float: StdUsed;

var float: Profit;

% Constraints
constraint forall(i in SYS) (Prod[i] >= 0.0);
constraint forall(i in SYS) (AltUsed[i] >= 0.0);
constraint forall(i in SYS) (StdUsed[i] >= 0.0);

constraint forall(i in SYS) (Prod[i] >= int2float(Preorder[i]));
constraint forall(i in SYS) (Prod[i] <= int2float(Demand[i]));

constraint sum(i in SYS)(Prod[i]) <= int2float(MaxCpu);

constraint sum(i in SYS where not IsWorkstation[i])(Prod[i]) <= int2float(DemandGP);
constraint sum(i in SYS where IsWorkstation[i])(Prod[i]) <= int2float(DemandWS);

constraint sum(i in SYS)(DiskDrives[i] * Prod[i]) >= int2float(MinDisk);
constraint sum(i in SYS)(DiskDrives[i] * Prod[i]) <= int2float(MaxDisk);

constraint forall(i in SYS) (
  StdUsed[i] + AltUsed[i] = int2float(MemoryBoards[i]) * Prod[i]
);

constraint forall(i in SYS where not AltCompatible[i]) (AltUsed[i] = 0.0);

constraint sum(i in SYS)(AltUsed[i]) <= int2float(AltMemory);

constraint sum(i in SYS)(StdUsed[i]) >= int2float(MinMemory);
constraint sum(i in SYS)(StdUsed[i]) <= int2float(MaxMemory);

constraint Profit = sum(i in SYS)(int2float(Price[i]) * Prod[i]);

solve maximize Profit;