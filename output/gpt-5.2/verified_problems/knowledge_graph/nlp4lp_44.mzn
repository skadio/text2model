include "globals.mzn";

int: N;
float: Capacity;
array[1..N] of float: Size;

% Upper bound on number of disks: one per file
int: D = N;

set of int: FILES = 1..N;
set of int: DISKS = 1..D;

% disk_of[j] = disk index assigned to file j
array[FILES] of var DISKS: Distribution;

% disk_used[d] = 1 if disk d is used
array[DISKS] of var 0..1: disk_used;

constraint
  forall(d in DISKS) (
    sum(j in FILES)(Size[j] * bool2int(Distribution[j] == d)) <= Capacity
  );

constraint
  forall(d in DISKS, j in FILES) (
    bool2int(Distribution[j] == d) <= disk_used[d]
  );

% Symmetry breaking: use disks in order (no gaps)
constraint forall(d in 2..D) (disk_used[d] <= disk_used[d-1]);

solve minimize sum(d in DISKS)(disk_used[d]);

output [
  "min_disks=", show(sum(d in DISKS)(disk_used[d])), "\n",
  "Distribution=", show(Distribution), "\n",
  "disk_used=", show(disk_used), "\n"
];