% Parameters
int: N; % Number of files
float: Capacity; % Total capacity of a floppy disk
array[1..N] of float: Size; % Size of each file

% Variables
% The number of floppy disks used
var int: num_disks = max(Size) div Capacity + 1;
% The disk on which each file is placed
array[1..N] of var 1..num_disks: disk;

% Constraints
% Each file must be placed on a disk
constraint forall(i in 1..N)(disk[i] >= 1);
% The total size of the files on each disk must not exceed the disk's capacity
constraint forall(i in 1..num_disks)(
  sum(j in 1..N where disk[j] = i)(Size[j]) <= Capacity
);

% Objective
% Minimize the number of floppy disks used
solve minimize num_disks;