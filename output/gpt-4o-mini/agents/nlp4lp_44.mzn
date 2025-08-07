include "globals.mzn";

int: N;                          % Number of files
int: Capacity;                   % Capacity of a floppy disk
array[1..N] of float: Size;     % Sizes of each file

% Variables
array[1..N] of var 0..N: disk;  % disk[i] indicates which disk file i is placed on
array[1..N] of var 0..Capacity: used; % used[j] indicates the used capacity of disk j

% Constraints
% Ensure that the total size of files on each disk does not exceed its capacity
constraint forall(j in 1..N)(
    used[j] = sum(i in 1..N (disk[i] == j) * Size[i]) 
    -> used[j] <= Capacity
);

% Ensure that each file is assigned to exactly one disk
constraint forall(i in 1..N)(
    exists(j in 1..N)(disk[i] == j)
);

% Minimize the number of disks used
var 0..N: num_disks;
constraint num_disks = max(disk);

% Solve & output
solve minimize num_disks;
output [ "Disk assignments: ", show(disk), "\nUsed capacities: ", show(used), "\n" ];