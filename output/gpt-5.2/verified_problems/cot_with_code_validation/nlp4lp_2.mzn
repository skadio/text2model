% DEC Production Planning (LP with floats)

%-----------------------
% Parameters
%-----------------------
int: N;
set of int: SYS = 1..N;

array[SYS] of bool: IsWorkstation;
array[SYS] of int: Price;
array[SYS] of float: DiskDrives;          % avg disk drives per system
array[SYS] of int: MemoryBoards;          % 256K boards per system

int: MaxCpu;                              % 1 CPU per system

int: MinDisk;
int: MaxDisk;

int: MinMemory;
int: MaxMemory;

array[SYS] of int: Demand;
int: DemandGP;
int: DemandWS;

array[SYS] of int: Preorder;

int: AltMemory;                           % total alternative boards available
array[SYS] of bool: AltCompatible;        % whether alt boards can be used in system i

%-----------------------
% Decision variables
%-----------------------
array[SYS] of var 0.0..infinity: Produce; % number of systems (float allowed)
array[SYS] of var 0.0..infinity: AltUse;  % alternative boards used in system i (float)

var float: Profit;

%-----------------------
% Constraints
%-----------------------
% Meet preorders and respect per-system demand
constraint forall(i in SYS) (
  Produce[i] >= int2float(Preorder[i]) /\
  Produce[i] <= int2float(Demand[i])
);

% Alternative memory usage bounds and compatibility
constraint forall(i in SYS) (
  AltUse[i] <= Produce[i] /\
  (not AltCompatible[i] -> AltUse[i] = 0.0)
);

% CPU supply (1 CPU per system)
constraint sum(i in SYS)(Produce[i]) <= int2float(MaxCpu);

% Disk drives total bounds
constraint sum(i in SYS)(DiskDrives[i] * Produce[i]) >= int2float(MinDisk);
constraint sum(i in SYS)(DiskDrives[i] * Produce[i]) <= int2float(MaxDisk);

% Memory boards total bounds (alt boards substitute 256K boards 1-for-1)
constraint sum(i in SYS)(int2float(MemoryBoards[i]) * Produce[i] - AltUse[i]) >= int2float(MinMemory);
constraint sum(i in SYS)(int2float(MemoryBoards[i]) * Produce[i] - AltUse[i]) <= int2float(MaxMemory);

% Total alternative memory availability
constraint sum(i in SYS)(AltUse[i]) <= int2float(AltMemory);

% Family demand limits
constraint sum(i in SYS where not IsWorkstation[i])(Produce[i]) <= int2float(DemandGP);
constraint sum(i in SYS where IsWorkstation[i])(Produce[i]) <= int2float(DemandWS);

%-----------------------
% Objective
%-----------------------
constraint Profit = sum(i in SYS)(int2float(Price[i]) * Produce[i]);
solve maximize Profit;