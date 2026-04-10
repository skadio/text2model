% Parameters
int: N;                                  % Number of files
int: Capacity;                           % Capacity of each floppy disk (same units as Size)
array[1..N] of float: Size;              % Size of file j

% A safe upper bound on the number of disks needed is one disk per file
int: MaxDisks = N;                       % Maximum disks considered (derived parameter)

% Variables
array[1..MaxDisks, 1..N] of var 0..1: assign;
% assign[d,j] = 1 if file j is stored on disk d, else 0

array[1..MaxDisks] of var 0..1: useDisk;
% useDisk[d] = 1 if disk d is used, else 0

var 0..MaxDisks: numDisksUsed;
% Total number of disks used

% Constraints

% Each file must be assigned to exactly one disk
constraint
  forall(j in 1..N) (
    sum(d in 1..MaxDisks)(assign[d,j]) = 1
  );

% Disk capacity constraints: total size of files on a disk
% cannot exceed Capacity if the disk is used
constraint
  forall(d in 1..MaxDisks) (
    sum(j in 1..N)(Size[j] * int2float(assign[d,j])) <=
      int2float(Capacity) * int2float(useDisk[d])
  );

% Linking constraints: if a file is assigned to a disk, then the disk is used
constraint
  forall(d in 1..MaxDisks, j in 1..N) (
    assign[d,j] <= useDisk[d]
  );

% Define the number of disks used
constraint
  numDisksUsed = sum(d in 1..MaxDisks)(useDisk[d]);

% Objective
solve minimize numDisksUsed;