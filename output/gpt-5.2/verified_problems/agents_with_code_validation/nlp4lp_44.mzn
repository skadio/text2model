% Parameters
int: N;                                  % Number of files
float: Capacity;                          % Capacity of one floppy disk
array[1..N] of float: Size;               % Size of each file

% Helpful upper bound: at most one disk per file
int: MaxDisks = N;
set of int: FILES = 1..N;
set of int: DISKS = 1..MaxDisks;

% Variables
array[DISKS] of var bool: useDisk;              % true if disk d is used
array[DISKS, FILES] of var bool: onDisk;        % true if file j is placed on disk d
array[DISKS] of var float: usedCapacity;        % total size stored on disk d

% Constraints
% --- Variable domain bounds ---
constraint forall(d in DISKS)(
  0.0 <= usedCapacity[d] /\ usedCapacity[d] <= Capacity
);

% --- Define used capacity per disk from assigned files ---
constraint forall(d in DISKS)(
  usedCapacity[d] = sum(j in FILES)(Size[j] * bool2int(onDisk[d,j]))
);

% --- Each file must be placed on exactly one disk ---
constraint forall(j in FILES)(
  sum(d in DISKS)(bool2int(onDisk[d,j])) = 1
);

% --- Cannot place a file on an unused disk ---
constraint forall(d in DISKS, j in FILES)(
  onDisk[d,j] -> useDisk[d]
);

% --- Capacity applies only when disk is used (and forces usedCapacity=0 if unused) ---
constraint forall(d in DISKS)(
  usedCapacity[d] <= Capacity * bool2int(useDisk[d])
);

% --- Disk capacity feasibility (redundant but explicit/strengthening) ---
constraint forall(d in DISKS)(
  sum(j in FILES)(Size[j] * bool2int(onDisk[d,j])) <= Capacity
);

% --- Symmetry breaking: use disks in order (disk renaming symmetry) ---
constraint forall(d in 1..MaxDisks-1)(
  bool2int(useDisk[d]) >= bool2int(useDisk[d+1])
);

% --- Strengthened linking: if a disk is used it must contain at least one file ---
constraint forall(d in DISKS)(
  bool2int(useDisk[d]) <= sum(j in FILES)(bool2int(onDisk[d,j]))
);

% Objective
solve minimize sum(d in DISKS)(bool2int(useDisk[d]));