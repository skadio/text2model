% Parameters
int: N;
array[1..N] of bool: IsWorkstation;
array[1..N] of int: Price;
array[1..N] of float: DiskDrives;
array[1..N] of int: MemoryBoards;
int: MaxCpu;
int: MinDisk;
int: MaxDisk;
int: MinMemory;
int: MaxMemory;
array[1..N] of int: Demand;
int: DemandGP;
int: DemandWS;
array[1..N] of int: Preorder;
int: AltMemory;
array[1..N] of bool: AltCompatible;

% Variables
var float: produce[1..N] >= 0;
var float: alt_use[1..N] >= 0;

% Constraints
constraint forall(i in 1..N) produce[i] >= Preorder[i];
constraint forall(i in 1..N) produce[i] <= Demand[i];
constraint forall(i in 1..N) alt_use[i] <= produce[i] * MemoryBoards[i] * bool2int(AltCompatible[i]);

constraint sum(i in 1..N) produce[i] <= MaxCpu;

constraint sum(i in 1..N) produce[i] * DiskDrives[i] >= MinDisk;
constraint sum(i in 1..N) produce[i] * DiskDrives[i] <= MaxDisk;

constraint sum(i in 1..N) (produce[i] * MemoryBoards[i] - alt_use[i]) >= MinMemory;
constraint sum(i in 1..N) (produce[i] * MemoryBoards[i] - alt_use[i]) <= MaxMemory;

constraint sum(i in 1..N) alt_use[i] <= AltMemory;

constraint sum(i in 1..N where IsWorkstation[i]) produce[i] <= DemandWS;
constraint sum(i in 1..N where not IsWorkstation[i]) produce[i] <= DemandGP;

% Objective
solve maximize sum(i in 1..N) produce[i] * Price[i];