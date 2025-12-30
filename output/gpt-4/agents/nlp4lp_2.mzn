% Parameters
int: N; % Number of systems
array[1..N] of bool: IsWorkstation; % Whether system i is a workstation
array[1..N] of int: Price; % Price of system i
array[1..N] of int: DiskDrives; % Number of disk drives in system i
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
var float: total_profit; % Total profit
array[1..N] of var 0..MaxCpu: system_production; % Number of each system to produce
array[1..N] of var 0..AltMemory: alt_memory_usage; % Number of alternative memory used for each system

% Constraints

% Each system requires exactly 1 CPU
constraint forall(i in 1..N)(system_production[i] <= MaxCpu);

% The supply of disk drives is uncertain and is estimated by the manufacturer and has an upper and lower bound
constraint sum(i in 1..N)(system_production[i]*DiskDrives[i]) >= MinDisk;
constraint sum(i in 1..N)(system_production[i]*DiskDrives[i]) <= MaxDisk;

% The supply of 256k memory boards is also limited and has an upper and lower bound
constraint sum(i in 1..N)(system_production[i]*MemoryBoards[i]) >= MinMemory;
constraint sum(i in 1..N)(system_production[i]*MemoryBoards[i]) <= MaxMemory;

% For each system, there is an estimated maximum demand for the next quarter
constraint forall(i in 1..N)(system_production[i] <= Demand[i]);

% There is a maximum demand for the whole GP family and the whole WS family for the next quarter
constraint sum(i in 1..N where IsWorkstation[i] = false)(system_production[i]) <= DemandGP;
constraint sum(i in 1..N where IsWorkstation[i] = true)(system_production[i]) <= DemandWS;

% Included in the projections, is a preorder demand that has been received for each type of system that must be fulfilled in the next quarter
constraint forall(i in 1..N)(system_production[i] >= Preorder[i]);

% To address the shortage of 256K memory boards, DEC has access to some units of an alternative memory board that can only be used in certain systems
constraint forall(i in 1..N)(alt_memory_usage[i] <= if AltCompatible[i] then system_production[i] else 0 endif);

% The total number of alternative memory boards used cannot exceed the available supply
constraint sum(i in 1..N)(alt_memory_usage[i]) <= AltMemory;

% The total profit is the sum of the price of each system multiplied by the number of systems produced
constraint total_profit = sum(i in 1..N)(Price[i]*system_production[i]);

% Objective
solve maximize total_profit;