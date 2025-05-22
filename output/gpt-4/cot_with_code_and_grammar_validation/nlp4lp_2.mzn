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
array[1..N] of var 0.0..float(Demand[i]): Systems;
array[1..N] of var 0..MemoryBoards[i]: AltMemoryUsed;

% Constraints
constraint sum(i in 1..N)(Systems[i]) <= MaxCpu;
constraint sum(i in 1..N)(DiskDrives[i]*Systems[i]) >= MinDisk;
constraint sum(i in 1..N)(DiskDrives[i]*Systems[i]) <= MaxDisk;
constraint sum(i in 1..N)(MemoryBoards[i]*Systems[i] + AltMemoryUsed[i]) >= MinMemory;
constraint sum(i in 1..N)(MemoryBoards[i]*Systems[i] + AltMemoryUsed[i]) <= MaxMemory;
constraint sum(i in 1..N where not IsWorkstation[i])(Systems[i]) <= DemandGP;
constraint sum(i in 1..N where IsWorkstation[i])(Systems[i]) <= DemandWS;
constraint forall(i in 1..N)(Systems[i] >= Preorder[i]);
constraint sum(i in 1..N where AltCompatible[i])(AltMemoryUsed[i]) <= AltMemory;

% Objective
var int: Profit = sum(i in 1..N)(Price[i]*Systems[i]);
solve maximize Profit;