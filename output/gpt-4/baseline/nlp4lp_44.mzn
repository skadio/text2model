include "globals.mzn";

% Number of files
int: N;

% Total capacity of a floppy disk
int: Capacity;

% Size of each file
array[1..N] of int: Size;

% Decision variable: which floppy disk each file is assigned to
array[1..N] of var 1..N: floppy;

% Decision variable: the number of floppy disks used
var 1..N: num_floppies;

% Constraint: the total size of the files on each floppy disk must not exceed its capacity
constraint forall(i in 1..N)(
  sum(j in 1..N)(Size[j] * bool2int(floppy[j] = i)) <= Capacity
);

% Constraint: the number of floppy disks used is the maximum floppy disk number assigned to a file
constraint num_floppies = max(floppy);

% Objective: minimize the number of floppy disks used
solve minimize num_floppies;

% Output: the floppy disk each file is assigned to and the number of floppy disks used
output ["File " ++ show(i) ++ " is assigned to floppy disk " ++ show(floppy[i]) | i in 1..N] ++
       ["\nNumber of floppy disks used: " ++ show(num_floppies)];