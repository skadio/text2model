include "globals.mzn";

% Data from .dzn file
int: N;                        % Number of files
float: Capacity;               % Capacity of one floppy disk
array[1..N] of float: Size;    % Size of each file

% Decision Variables
% Each file j is assigned to a disk with index in 1..N.
array[1..N] of var 1..N: bin;
% used[i] = 1 if disk i is used, 0 otherwise.
array[1..N] of var 0..1: used;

% Constraints
% For each disk i, the sum of file sizes assigned to it must not exceed its capacity if it is used.
constraint
  forall(i in 1..N) (
    sum(j in 1..N)( if bin[j] = i then Size[j] else 0.0 endif ) <= Capacity * used[i]
  );

% Symmetry breaking: ensure that if disk i is not used then no disk with a higher index is used.
constraint
  forall(i in 1..N-1) (
    used[i] >= used[i+1]
  );

% Objective: minimize the total number of disks used.
solve minimize sum(i in 1..N)(used[i]);

% Output block: show minimal number of disks, and the disk assignment for each file.
output [
  "Number of disks used: ", show(sum(i in 1..N)(used[i])), "\n",
  "File assignments (file -> disk): ", show(bin), "\n"
];