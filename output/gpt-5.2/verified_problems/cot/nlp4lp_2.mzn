% Parameters
int: N;
set of int: SYS = 1..N;

array[SYS] of bool: IsWorkstation;
array[SYS] of int: Price;
array[SYS] of float: DiskDrives;
array[SYS] of int: MemoryBoards;

int: MaxCpu;

int: MinDisk;
int: MaxDisk;

int: MinMemory;
int: MaxMemory;

array[SYS] of int: Demand;
int: DemandGP;
int: DemandWS;

array[SYS] of int: Preorder;

int: AltMemory;
array[SYS] of bool: AltCompatible;

% Variables
array[SYS] of var float: Produce;        % number of systems produced (continuous)
array[SYS] of var float: MemOrig;        % original 256K memory boards allocated to system i (total boards)
array[SYS] of var float: MemAlt;         % alternative memory boards allocated to system i (total boards)

% Constraints
constraint forall(i in SYS) (Produce[i] >= int2float(Preorder[i]));
constraint forall(i in SYS) (Produce[i] <= int2float(Demand[i]));
constraint forall(i in SYS) (Produce[i] >= 0.0);

% One CPU per system
constraint sum(i in SYS)(Produce[i]) <= int2float(MaxCpu);

% Disk supply bounds (drives are consumed proportionally by produced systems)
constraint sum(i in SYS)(DiskDrives[i] * Produce[i]) >= int2float(MinDisk);
constraint sum(i in SYS)(DiskDrives[i] * Produce[i]) <= int2float(MaxDisk);

% Memory accounting: each system needs MemoryBoards[i] boards, met by original or alternative
constraint forall(i in SYS) (MemOrig[i] >= 0.0 /\ MemAlt[i] >= 0.0);
constraint forall(i in SYS) (
  MemOrig[i] + MemAlt[i] = int2float(MemoryBoards[i]) * Produce[i]
);

% Alternative memory compatibility
constraint forall(i in SYS where not AltCompatible[i]) (MemAlt[i] = 0.0);

% Original memory supply bounds
constraint sum(i in SYS)(MemOrig[i]) >= int2float(MinMemory);
constraint sum(i in SYS)(MemOrig[i]) <= int2float(MaxMemory);

% Alternative memory supply limit
constraint sum(i in SYS)(MemAlt[i]) <= int2float(AltMemory);

% Family demand limits
constraint sum(i in SYS where not IsWorkstation[i])(Produce[i]) <= int2float(DemandGP);
constraint sum(i in SYS where IsWorkstation[i])(Produce[i]) <= int2float(DemandWS);

% Objective
solve maximize sum(i in SYS)(int2float(Price[i]) * Produce[i]);