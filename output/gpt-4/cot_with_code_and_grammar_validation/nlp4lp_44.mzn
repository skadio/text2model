% Parameters
int: N; % Number of files
float: Capacity; % Total capacity of a floppy disk
array[1..N] of float: Size; % Size of each file

% Variables
var 1..N: disks; % Number of disks used
array[1..N, 1..N] of var 0..1: x; % x[i,j] = 1 if file j is stored on disk i, 0 otherwise

% Constraints
% Each file is stored on exactly one disk
constraint forall(j in 1..N)(sum(i in 1..N)(x[i,j]) = 1);

% The total size of files on each disk does not exceed the disk's capacity
constraint forall(i in 1..N)(sum(j in 1..N)(x[i,j]*Size[j]) <= Capacity);

% The number of disks used is at least the number of disks with at least one file
constraint disks >= sum(i in 1..N)(bool2int(sum(j in 1..N)(x[i,j]) > 0));

% Objective
% Minimize the number of disks used
solve minimize disks;