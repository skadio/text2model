% Parameters
int: N; % Number of files
int: Capacity; % Total capacity of a floppy disk
array[1..N] of int: Size; % Size of each file

% Variables
% Number of floppy disks used for each file
array[1..N] of var 0..N: floppy_disks_used;
% Total number of floppy disks used
var 0..N: total_floppy_disks_used;

% Constraints

% Each file must be stored on a floppy disk
constraint forall(i in 1..N) (
  floppy_disks_used[i] >= 1
);

% The size of the files on each floppy disk must not exceed its capacity
constraint forall(i in 1..N) (
  Size[i] * floppy_disks_used[i] <= Capacity
);

% The total number of floppy disks used is the sum of the number of floppy disks used for each file
constraint total_floppy_disks_used = sum(i in 1..N) (floppy_disks_used[i]);

% Objective
solve minimize total_floppy_disks_used;