% Parameters
int: N; % Number of files
int: Capacity; % Total capacity of a floppy disk
array[1..N] of int: Size; % Size of each file

% Variables
% The floppy disk on which each file is stored
array[1..N] of var 1..N: floppy_disk;
% The total number of floppy disks used
var 1..N: total_floppy_disks_used;

% Constraints

% The total size of the files on each floppy disk must not exceed its capacity
constraint forall(i in 1..total_floppy_disks_used) (
    sum(j in 1..N where floppy_disk[j] = i) (Size[j]) <= Capacity
);

% The total number of floppy disks used is the maximum floppy disk number used
constraint total_floppy_disks_used = max(floppy_disk);

% Objective
solve minimize total_floppy_disks_used;