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
var float: total_profit;
array[1..N] of var 0.0..1.0: Systems;
array[1..N] of var 0..1: UseAltMemory;

% Constraints
constraint forall(i in 1..N)(Systems[i] >= Preorder[i]);
constraint sum(i in 1..N)(Systems[i]) <= MaxCpu;
constraint sum(i in 1..N)(DiskDrives[i]*Systems[i]) >= MinDisk;
constraint sum(i in 1..N)(DiskDrives[i]*Systems[i]) <= MaxDisk;
constraint sum(i in 1..N)(MemoryBoards[i]*Systems[i]) >= MinMemory;
constraint sum(i in 1..N)(MemoryBoards[i]*Systems[i]) <= MaxMemory;
constraint sum(i in 1..N where IsWorkstation[i])(Systems[i]) <= DemandWS;
constraint sum(i in 1..N where not IsWorkstation[i])(Systems[i]) <= DemandGP;
constraint forall(i in 1..N)(Systems[i] <= Demand[i]);
constraint sum(i in 1..N where AltCompatible[i])(UseAltMemory[i]*Systems[i]) <= AltMemory;
constraint forall(i in 1..N where not AltCompatible[i])(UseAltMemory[i] = 0);

% Objective
total_profit = sum(i in 1..N)(Price[i]*Systems[i]);
solve maximize total_profit;