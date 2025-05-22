% Parameters
int: N;
array[1..N] of bool: IsWorkstation;
array[1..N] of int:  Price;
array[1..N] of float: DiskDrives;
array[1..N] of int:  MemoryBoards;

int: MaxCpu;

float: MinDisk;
float: MaxDisk;

int: MinMemory;
int: MaxMemory;

array[1..N] of int: Demand;
int: DemandGP;
int: DemandWS;
array[1..N] of int: Preorder;

int: AltMemory;
array[1..N] of bool: AltCompatible;

% Decision variables
array[1..N] of var float: Production;   % systems to produce
array[1..N] of var float: AltUse;       % alternative memory boards used

% Non-negativity
constraint forall(i in 1..N)(Production[i] >= 0.0);
constraint forall(i in 1..N)(AltUse[i]      >= 0.0);

% Pre-orders and individual demand limits
constraint forall(i in 1..N)(
          Production[i] >= Preorder[i] /\
          Production[i] <= Demand[i]
);

% Family demand limits
constraint sum(i in 1..N where not IsWorkstation[i])(Production[i]) <= DemandGP;
constraint sum(i in 1..N where     IsWorkstation[i])(Production[i]) <= DemandWS;

% CPU availability (1 CPU per system)
constraint sum(i in 1..N)(Production[i]) <= MaxCpu;

% Disk-drive availability
constraint sum(i in 1..N)(DiskDrives[i] * Production[i]) >= MinDisk;
constraint sum(i in 1..N)(DiskDrives[i] * Production[i]) <= MaxDisk;

% Alternative memory compatibility
constraint forall(i in 1..N where not AltCompatible[i])(AltUse[i] = 0.0);

% Alternative memory cannot exceed memory boards required for that system
constraint forall(i in 1..N)(
          AltUse[i] <= MemoryBoards[i] * Production[i]
);

% Overall alternative memory limit
constraint sum(i in 1..N)(AltUse[i]) <= AltMemory;

% Standard 256K memory board availability (after substitution)
constraint
  sum(i in 1..N)(MemoryBoards[i] * Production[i]) - sum(i in 1..N)(AltUse[i]) >= MinMemory;
constraint
  sum(i in 1..N)(MemoryBoards[i] * Production[i]) - sum(i in 1..N)(AltUse[i]) <= MaxMemory;

% Objective: maximise profit
var float: Profit = sum(i in 1..N)(Price[i] * Production[i]);

solve maximize Profit;