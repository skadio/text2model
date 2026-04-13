% Parameters
int: N;                                      % Number of systems
set of int: SYS = 1..N;                      % Index set of systems

array[SYS] of bool: IsWorkstation;           % true if system i is a workstation (WS), else GP
array[SYS] of int: Price;                    % Price (revenue) per unit of system i (dollars)
array[SYS] of float: DiskDrives;             % Average disk drives required per unit of system i
array[SYS] of int: MemoryBoards;             % 256K memory boards required per unit of system i

int: MaxCpu;                                 % Max CPUs available (1 CPU per system)
int: MinDisk;                                % Min total disk drives available
int: MaxDisk;                                % Max total disk drives available
int: MinMemory;                              % Min total 256K memory boards available
int: MaxMemory;                              % Max total 256K memory boards available

array[SYS] of int: Demand;                   % Max demand for each system i
int: DemandGP;                               % Max demand for all GP systems combined
int: DemandWS;                               % Max demand for all WS systems combined

array[SYS] of int: Preorder;                 % Preorder quantity that must be met for each system i

int: AltMemory;                              % Total alternative memory boards available
array[SYS] of bool: AltCompatible;           % true if alternative memory can be used in system i

% Variables
array[SYS] of var float: Produce;            % Units of system i to produce (continuous)
array[SYS] of var float: StdMemUsed;         % Standard 256K memory boards used by system i
array[SYS] of var float: AltMemUsed;         % Alternative memory boards used by system i

% Constraints

% --- Demand satisfaction & preorder fulfillment (per system) ---
constraint
  forall(i in SYS) (
    Produce[i] >= int2float(Preorder[i]) /\
    Produce[i] <= int2float(Demand[i])
  );

% --- Family (GP / WS) aggregate demand limits ---
constraint
  sum(i in SYS where not IsWorkstation[i]) (Produce[i]) <= int2float(DemandGP);

constraint
  sum(i in SYS where IsWorkstation[i]) (Produce[i]) <= int2float(DemandWS);

% --- CPU capacity (1 CPU per produced system) ---
constraint
  sum(i in SYS) (Produce[i]) <= int2float(MaxCpu);

% --- Disk drive supply bounds (total average drives used) ---
constraint
  sum(i in SYS) (DiskDrives[i] * Produce[i]) >= int2float(MinDisk);

constraint
  sum(i in SYS) (DiskDrives[i] * Produce[i]) <= int2float(MaxDisk);

% --- Memory accounting per system (standard vs alternative) ---
constraint
  forall(i in SYS) (
    StdMemUsed[i] >= 0.0 /\
    AltMemUsed[i] >= 0.0 /\
    StdMemUsed[i] + AltMemUsed[i] = int2float(MemoryBoards[i]) * Produce[i]
  );

% --- Alternative memory compatibility: forbid use where not compatible ---
constraint
  forall(i in SYS where not AltCompatible[i]) (
    AltMemUsed[i] = 0.0
  );

% --- Total alternative memory availability ---
constraint
  sum(i in SYS) (AltMemUsed[i]) <= int2float(AltMemory);

% --- Total standard 256K memory board supply bounds ---
constraint
  sum(i in SYS) (StdMemUsed[i]) >= int2float(MinMemory);

constraint
  sum(i in SYS) (StdMemUsed[i]) <= int2float(MaxMemory);

% Objective
solve maximize sum(i in SYS) (int2float(Price[i]) * Produce[i]);