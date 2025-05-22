% Parameters
int: N; % Number of files
float: Capacity; % Total capacity of a floppy disk
array[1..N] of float: Size; % Size of each file

% Variables
var 0..N: num_disks; % Number of disks used
array[1..N, 1..N] of var 0..1: x; % x[i,j] = 1 if file j is stored on disk i, 0 otherwise

% Constraints
constraint forall(i in 1..N)(sum(j in 1..N)(x[i,j]*Size[j]) <= Capacity); % The total size of files on each disk should not exceed its capacity
constraint forall(j in 1..N)(sum(i in 1..N)(x[i,j]) = 1); % Each file should be stored on exactly one disk
constraint num_disks = max(i in 1..N)(sum(j in 1..N)(x[i,j]) > 0); % The number of disks used is the maximum index of a disk that has at least one file

% Objective
solve minimize num_disks; % Minimize the number of disks used