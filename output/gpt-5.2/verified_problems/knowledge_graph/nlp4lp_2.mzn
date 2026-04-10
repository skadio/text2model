int: N;
set of int: SYS = 1..N;

array[SYS] of bool: IsWorkstation;
array[SYS] of float: Price;
array[SYS] of float: DiskDrives;     % average disk drives per system
array[SYS] of float: MemoryBoards;   % 256K boards per system

float: MaxCpu;      % each system uses 1 CPU
float: MinDisk;
float: MaxDisk;
float: MinMemory;
float: MaxMemory;

array[SYS] of float: Demand;
float: DemandGP;
float: DemandWS;

array[SYS] of float: Preorder;

float: AltMemory;                 % total available alternative memory units (as board-equivalents)
array[SYS] of bool: AltCompatible;

% Decision variables
array[SYS] of var float: x;        % systems produced (can be fractional)
array[SYS] of var float: altUse;   % alternative memory units used on system i (board-equivalents)

% Basic bounds
constraint forall(i in SYS) ( x[i] >= Preorder[i] /\ x[i] <= Demand[i] );
constraint forall(i in SYS) ( altUse[i] >= 0.0 /\ altUse[i] <= (if AltCompatible[i] then MemoryBoards[i] * x[i] else 0.0 endif) );

% CPU capacity (1 CPU per system)
constraint sum(i in SYS)(x[i]) <= MaxCpu;

% Disk drives availability (total)
constraint MinDisk <= sum(i in SYS)(DiskDrives[i] * x[i]);
constraint sum(i in SYS)(DiskDrives[i] * x[i]) <= MaxDisk;

% Memory boards availability (total), allowing substitution by alternative memory where compatible
constraint MinMemory <= sum(i in SYS)(MemoryBoards[i] * x[i] - altUse[i]);
constraint sum(i in SYS)(MemoryBoards[i] * x[i] - altUse[i]) <= MaxMemory;

% Alternative memory availability (total)
constraint sum(i in SYS)(altUse[i]) <= AltMemory;

% Family demand caps
constraint sum(i in SYS where not IsWorkstation[i])(x[i]) <= DemandGP;
constraint sum(i in SYS where IsWorkstation[i])(x[i]) <= DemandWS;

% Objective: maximize profit (no explicit costs provided, so maximize revenue)
var float: Profit = sum(i in SYS)(Price[i] * x[i]);
solve maximize Profit;

output [
  "Profit=", show(Profit), "\n",
  "x=", show(x), "\n",
  "altUse=", show(altUse), "\n",
  "TotalCPU=", show(sum(i in SYS)(x[i])), "\n",
  "TotalDisk=", show(sum(i in SYS)(DiskDrives[i]*x[i])), "\n",
  "TotalMem256K=", show(sum(i in SYS)(MemoryBoards[i]*x[i] - altUse[i])), "\n",
  "TotalAltMem=", show(sum(i in SYS)(altUse[i])), "\n"
];