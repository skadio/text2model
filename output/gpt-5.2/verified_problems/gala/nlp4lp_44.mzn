include "globals.mzn";

% ---------- Input ----------
int: N;                         % number of files
float: Capacity;                % capacity of each floppy disk
array[1..N] of float: Size;     % file sizes

% Upper bound on number of disks: one per file
int: M = N;

% ---------- Decision variables ----------
% disk assignment for each file (1..M)
array[1..N] of var 1..M: diskOf;

% whether disk d is used
array[1..M] of var bool: used;

% ---------- Constraints ----------
% Link used[d] to whether any file is assigned to disk d
constraint forall(d in 1..M)(
  used[d] <-> exists(i in 1..N)(diskOf[i] = d)
);

% Capacity constraint for each disk
constraint forall(d in 1..M)(
  sum(i in 1..N)( Size[i] * bool2int(diskOf[i] = d) ) <= Capacity
);

% Symmetry breaking: use disks from 1 upward (no gaps)
constraint forall(d in 1..M-1)( used[d+1] -> used[d] );

% ---------- Objective ----------
var 0..M: numDisks = sum(d in 1..M)(bool2int(used[d]));
solve minimize numDisks;

% ---------- Output ----------
output [
  "numDisks = ", show(numDisks), "\n",
  "diskOf = ", show(diskOf), "\n",
  "used = ", show(used), "\n",
  "loads = ", show([ sum(i in 1..N)( Size[i] * bool2int(diskOf[i] = d) ) | d in 1..M ]), "\n"
];