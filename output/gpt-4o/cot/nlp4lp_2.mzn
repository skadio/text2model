% Parameters
int: N;
set of int: Systems = 1..N;

array[Systems] of bool: IsWorkstation;
array[Systems] of int: Price;
array[Systems] of float: DiskDrives;
array[Systems] of int: MemoryBoards;

int: MaxCpu;

float: MinDisk;
float: MaxDisk;

int: MinMemory;
int: MaxMemory;

array[Systems] of int: Demand;
int: DemandGP;
int: DemandWS;

array[Systems] of int: Preorder;

int: AltMemory;
array[Systems] of bool: AltCompatible;


% Variables
array[Systems] of var 0.0..float(MaxCpu): Produced;
array[Systems] of var 0.0..float(AltMemory): AltUsed;


% Constraints

% Basic production bounds
constraint forall(i in Systems)(
    Produced[i] >= float(Preorder[i]) /\
    Produced[i] <= float(Demand[i])
);

% Alternative memory usage bounds
constraint forall(i in Systems)(
    AltUsed[i] <= Produced[i]
);
constraint forall(i in Systems where not AltCompatible[i])(
    AltUsed[i] = 0.0
);

% CPU availability
constraint sum(i in Systems)(Produced[i]) <= float(MaxCpu);

% Disk-drive availability
constraint sum(i in Systems)(DiskDrives[i] * Produced[i]) >= MinDisk;
constraint sum(i in Systems)(DiskDrives[i] * Produced[i]) <= MaxDisk;

% 256K memory board availability
constraint
    sum(i in Systems)( float(MemoryBoards[i]) * AltUsed[i]) <= float(AltMemory);

constraint
    sum(i in Systems)( float(MemoryBoards[i]) * (Produced[i] - AltUsed[i])) >= float(MinMemory);
constraint
    sum(i in Systems)( float(MemoryBoards[i]) * (Produced[i] - AltUsed[i])) <= float(MaxMemory);

% Family demand limits
constraint
    sum(i in Systems where not IsWorkstation[i])(Produced[i]) <= float(DemandGP);
constraint
    sum(i in Systems where  IsWorkstation[i])(Produced[i]) <= float(DemandWS);


% Objective
solve maximize
    sum(i in Systems)( float(Price[i]) * Produced[i] );