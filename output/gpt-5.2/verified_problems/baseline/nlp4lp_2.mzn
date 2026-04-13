% DEC Computer Systems Production Planning (LP with floats)

int: N;
set of int: SYS = 1..N;

array[SYS] of bool: IsWorkstation;
array[SYS] of float: Price;
array[SYS] of float: DiskDrives;      % average disk drives per system
array[SYS] of float: MemoryBoards;    % 256K boards per system (standard)
array[SYS] of float: Demand;
array[SYS] of float: Preorder;

float: MaxCpu;

float: MinDisk;
float: MaxDisk;

float: MinMemory;
float: MaxMemory;

float: DemandGP;
float: DemandWS;

float: AltMemory;                    % total alternative memory boards available
array[SYS] of bool: AltCompatible;

% Decision variables
array[SYS] of var float: Produce;     % number of systems of type i to produce (can be fractional)
array[SYS] of var float: UseAlt;      % alternative memory boards allocated to system i (boards, not systems)

% Helper expressions
var float: TotalSystems = sum(i in SYS)(Produce[i]);
var float: TotalDisk    = sum(i in SYS)(DiskDrives[i] * Produce[i]);
var float: TotalStdMem  = sum(i in SYS)(MemoryBoards[i] * Produce[i]) - sum(i in SYS)(UseAlt[i]);
var float: TotalAltMem  = sum(i in SYS)(UseAlt[i]);

% Constraints
constraint forall(i in SYS)(
  Produce[i] >= Preorder[i] /\
  Produce[i] <= Demand[i] /\
  Produce[i] >= 0.0
);

% CPU supply (1 CPU per system)
constraint TotalSystems <= MaxCpu;

% Disk supply bounds
constraint TotalDisk >= MinDisk;
constraint TotalDisk <= MaxDisk;

% Memory board supply bounds (standard boards)
constraint TotalStdMem >= MinMemory;
constraint TotalStdMem <= MaxMemory;

% Alternative memory availability and compatibility
constraint forall(i in SYS)(
  UseAlt[i] >= 0.0 /\
  UseAlt[i] <= (if AltCompatible[i] then MemoryBoards[i] * Produce[i] else 0.0 endif)
);
constraint TotalAltMem <= AltMemory;

% Family demand constraints
constraint sum(i in SYS where not IsWorkstation[i])(Produce[i]) <= DemandGP;
constraint sum(i in SYS where IsWorkstation[i])(Produce[i]) <= DemandWS;

% Objective: maximize profit (revenue only, since no costs are provided)
solve maximize sum(i in SYS)(Price[i] * Produce[i]);

output [
  "TotalSystems = ", show(TotalSystems), "\n",
  "TotalDisk = ", show(TotalDisk), "\n",
  "TotalStdMem = ", show(TotalStdMem), "\n",
  "TotalAltMem = ", show(TotalAltMem), "\n\n",
  "Produce = ", show(Produce), "\n",
  "UseAlt = ", show(UseAlt), "\n"
];