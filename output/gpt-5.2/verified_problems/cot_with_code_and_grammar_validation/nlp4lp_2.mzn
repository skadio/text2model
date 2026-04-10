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
array[SYS] of var float: x;
array[SYS] of var float: altMemUse;
array[SYS] of var float: stdMemUse;

var float: TotalProfit;

% Constraints
constraint forall(i in SYS) (x[i] >= 0.0);
constraint forall(i in SYS) (altMemUse[i] >= 0.0);
constraint forall(i in SYS) (stdMemUse[i] >= 0.0);

constraint forall(i in SYS) (x[i] <= int2float(Demand[i]));
constraint forall(i in SYS) (x[i] >= int2float(Preorder[i]));

constraint sum(i in SYS) (x[i]) <= int2float(MaxCpu);

constraint sum(i in SYS where not IsWorkstation[i]) (x[i]) <= int2float(DemandGP);
constraint sum(i in SYS where IsWorkstation[i]) (x[i]) <= int2float(DemandWS);

constraint sum(i in SYS) (DiskDrives[i] * x[i]) >= int2float(MinDisk);
constraint sum(i in SYS) (DiskDrives[i] * x[i]) <= int2float(MaxDisk);

constraint forall(i in SYS) (
  stdMemUse[i] + altMemUse[i] = int2float(MemoryBoards[i]) * x[i]
);

constraint forall(i in SYS where not AltCompatible[i]) (altMemUse[i] = 0.0);

constraint sum(i in SYS) (stdMemUse[i]) >= int2float(MinMemory);
constraint sum(i in SYS) (stdMemUse[i]) <= int2float(MaxMemory);

constraint sum(i in SYS) (altMemUse[i]) <= int2float(AltMemory);

constraint TotalProfit = sum(i in SYS) (int2float(Price[i]) * x[i]);

solve maximize TotalProfit;

output [
  "TotalProfit=", show(TotalProfit), "\n",
  "x=", show(x), "\n",
  "stdMemUse=", show(stdMemUse), "\n",
  "altMemUse=", show(altMemUse), "\n"
];