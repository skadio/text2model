% Parameters
int: N;                                  % Number of systems
set of int: SYSTEMS = 1..N;              % Index set of systems

array[SYSTEMS] of bool: IsWorkstation;   % True if system i is a workstation (WS), else general-purpose (GP)
array[SYSTEMS] of int: Price;            % Price (profit contribution) per unit of system i (dollars)
array[SYSTEMS] of float: DiskDrives;     % Average disk drives required per unit of system i
array[SYSTEMS] of int: MemoryBoards;     % 256K memory boards required per unit of system i

int: MaxCpu;                             % Maximum CPUs available (each system requires 1 CPU)

int: MinDisk;                            % Minimum total disk drives available
int: MaxDisk;                            % Maximum total disk drives available
int: MinMemory;                          % Minimum total 256K memory boards available
int: MaxMemory;                          % Maximum total 256K memory boards available

array[SYSTEMS] of int: Demand;           % Maximum demand for system i next quarter
int: DemandGP;                           % Maximum demand for all GP systems combined
int: DemandWS;                           % Maximum demand for all WS systems combined

array[SYSTEMS] of int: Preorder;         % Preorder requirement for system i (must be fulfilled)

int: AltMemory;                          % Total alternative memory boards available
array[SYSTEMS] of bool: AltCompatible;   % True if alternative memory can be used in system i


% Variables
array[SYSTEMS] of var float: Produce;    % Number of systems i produced (can be fractional)

array[SYSTEMS] of var float: UseStdMem;  % Standard 256K memory boards used by system i
array[SYSTEMS] of var float: UseAltMem;  % Alternative memory boards used by system i

var float: TotalRevenue;                 % Total profit/revenue objective value


% Constraints

%--- Production must satisfy preorder and cannot exceed item-level demand ---
constraint
  forall(i in SYSTEMS) (
    Produce[i] >= int2float(Preorder[i]) /\
    Produce[i] <= int2float(Demand[i])
  );

%--- Family (GP vs WS) maximum demand constraints ---
constraint
  sum(i in SYSTEMS where not IsWorkstation[i]) (Produce[i]) <= int2float(DemandGP);

constraint
  sum(i in SYSTEMS where IsWorkstation[i]) (Produce[i]) <= int2float(DemandWS);

%--- CPU capacity: each produced system consumes exactly 1 CPU ---
constraint
  sum(i in SYSTEMS) (Produce[i]) <= int2float(MaxCpu);

%--- Disk drives availability bounds (average drives per produced system) ---
constraint
  sum(i in SYSTEMS) (DiskDrives[i] * Produce[i]) >= int2float(MinDisk);

constraint
  sum(i in SYSTEMS) (DiskDrives[i] * Produce[i]) <= int2float(MaxDisk);

%--- Memory balance per system: standard + alternative must cover required boards ---
constraint
  forall(i in SYSTEMS) (
    UseStdMem[i] + UseAltMem[i] = int2float(MemoryBoards[i]) * Produce[i]
  );

%--- Standard 256K memory boards availability bounds ---
constraint
  sum(i in SYSTEMS) (UseStdMem[i]) >= int2float(MinMemory);

constraint
  sum(i in SYSTEMS) (UseStdMem[i]) <= int2float(MaxMemory);

%--- Alternative memory global availability bound ---
constraint
  sum(i in SYSTEMS) (UseAltMem[i]) <= int2float(AltMemory);

%--- Alternative memory compatibility: forbid alt use on incompatible systems ---
constraint
  forall(i in SYSTEMS where not AltCompatible[i]) (
    UseAltMem[i] = 0.0
  );

%--- Nonnegativity of continuous decision variables ---
constraint
  forall(i in SYSTEMS) (
    Produce[i] >= 0.0 /\ UseStdMem[i] >= 0.0 /\ UseAltMem[i] >= 0.0
  );


% Objective
constraint TotalRevenue = sum(i in SYSTEMS) (int2float(Price[i]) * Produce[i]);

solve maximize TotalRevenue;