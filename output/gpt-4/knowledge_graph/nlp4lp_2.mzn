include "globals.mzn";

% Parameters
int: N; % Number of systems
array[1..N] of bool: IsWorkstation; % Whether system i is a workstation
array[1..N] of int: Price; % Price of system i
array[1..N] of float: DiskDrives; % Number of disk drives in system i
array[1..N] of int: MemoryBoards; % Number of 256K memory boards in system i
int: MaxCpu; % Maximum number of CPUs available
int: MinDisk; % Minimum total disk drives
int: MaxDisk; % Maximum total disk drives
int: MinMemory; % Minimum total memory boards
int: MaxMemory; % Maximum total memory boards
array[1..N] of int: Demand; % Demand of system i
int: DemandGP; % Demand for General Purpose systems
int: DemandWS; % Demand for Workstations
array[1..N] of int: Preorder; % Number of preordered system i
int: AltMemory; % Number of alternative memory configurations possible
array[1..N] of bool: AltCompatible; % Whether the alternative memory is compatible with system i

% Variables
array[1..N] of var 0..Demand[i]: Production; % Number of each system to produce
var 0..AltMemory: AltMemoryUsed; % Number of alternative memory configurations used

% Constraints
constraint sum(i in 1..N)(Production[i]) <= MaxCpu; % CPU constraint
constraint sum(i in 1..N)(Production[i]*DiskDrives[i]) >= MinDisk; % Minimum disk constraint
constraint sum(i in 1..N)(Production[i]*DiskDrives[i]) <= MaxDisk; % Maximum disk constraint
constraint sum(i in 1..N)(Production[i]*MemoryBoards[i]) + AltMemoryUsed >= MinMemory; % Minimum memory constraint
constraint sum(i in 1..N)(Production[i]*MemoryBoards[i]) + AltMemoryUsed <= MaxMemory; % Maximum memory constraint
constraint sum(i in 1..N)(Production[i]*(1-IsWorkstation[i])) <= DemandGP; % GP demand constraint
constraint sum(i in 1..N)(Production[i]*IsWorkstation[i]) <= DemandWS; % WS demand constraint
constraint forall(i in 1..N)(Production[i] >= Preorder[i]); % Preorder constraint
constraint sum(i in 1..N)(AltMemoryUsed*AltCompatible[i]) <= AltMemory; % Alternative memory constraint

% Objective
var int: Profit = sum(i in 1..N)(Production[i]*Price[i]);
solve maximize Profit;

% Output
output ["Profit: ", show(Profit), "\n"] ++
["Production: "] ++ [show(Production[i]) | i in 1..N];