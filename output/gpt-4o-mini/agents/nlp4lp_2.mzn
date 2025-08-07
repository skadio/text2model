include "globals.mzn";

int: N;  % Number of systems
array[1..N] of bool: IsWorkstation;  % Whether system i is a workstation
array[1..N] of int: Price;  % Price of system i
array[1..N] of float: DiskDrives;  % Number of disk drives in system i
array[1..N] of int: MemoryBoards;  % Number of 256K memory boards in system i
int: MaxCpu;  % Maximum number of CPUs available
int: MinDisk;  % Minimum total disk drives
int: MaxDisk;  % Maximum total disk drives
int: MinMemory;  % Minimum total memory boards
int: MaxMemory;  % Maximum total memory boards
array[1..N] of int: Demand;  % Demand of system i
int: DemandGP;  % Demand for General Purpose systems
int: DemandWS;  % Demand for Workstations
array[1..N] of int: Preorder;  % Number of preordered system i
int: AltMemory;  % Number of alternative memory configurations possible
array[1..N] of bool: AltCompatible;  % Whether the alternative memory is compatible with system i

% Decision variables: number of each system to produce
array[1..N] of var 0..float: x;  % Production quantities for each system

% Constraints
constraint sum(x) <= MaxCpu;  % Each system requires exactly 1 CPU
constraint sum(DiskDrives[i] * x[i] | i in 1..N) >= MinDisk;  % Minimum total disk drives
constraint sum(DiskDrives[i] * x[i] | i in 1..N) <= MaxDisk;  % Maximum total disk drives
constraint sum(MemoryBoards[i] * x[i] | i in 1..N) >= MinMemory;  % Minimum total memory boards
constraint sum(MemoryBoards[i] * x[i] | i in 1..N) <= MaxMemory;  % Maximum total memory boards

% Demand constraints
constraint forall(i in 1..N)(x[i] <= Demand[i] - Preorder[i]);  % Production cannot exceed demand minus preorders

% Demand for GP and WS systems
constraint sum(x[i] | i in 1..N where IsWorkstation[i] == false) <= DemandGP;  % Total GP production
constraint sum(x[i] | i in 1..N where IsWorkstation[i] == true) <= DemandWS;  % Total WS production

% Alternative memory constraints
constraint sum(AltCompatible[i] ? AltMemory : 0 | i in 1..N) >= sum(MemoryBoards[i] * x[i] | i in 1..N);

% Objective: Maximize profit
var float: profit = sum(Price[i] * x[i] | i in 1..N);
solve maximize profit;

% Output
output [ "Production quantities: ", show(x), "\nTotal Profit: ", show(profit), "\n" ];