int: N;
float: Capacity;
array[1..N] of float: Size;

set of int: FILES = 1..N;
set of int: DISKS = 1..N; % at most one file per disk -> N disks suffice

array[FILES, DISKS] of var bool: x;     % x[f,d] = file f stored on disk d
array[DISKS] of var bool: used;         % disk d is used

constraint
  forall(f in FILES) (
    sum(d in DISKS)(bool2int(x[f,d])) = 1
  );

constraint
  forall(d in DISKS) (
    sum(f in FILES)(Size[f] * bool2int(x[f,d])) <= Capacity
  );

constraint
  forall(d in DISKS) (
    sum(f in FILES)(bool2int(x[f,d])) <= N * bool2int(used[d])
  );

constraint
  forall(f in FILES, d in DISKS) (
    x[f,d] -> used[d]
  );

solve minimize sum(d in DISKS)(bool2int(used[d]));

output [
  "min_disks=", show(sum(d in DISKS)(bool2int(used[d]))), "\n",
  "assignment (file -> disk):\n"
] ++
[
  "file " ++ show(f) ++ " (size=" ++ show(Size[f]) ++ ") -> disk " ++
  show(sum(d in DISKS)(d * bool2int(x[f,d]))) ++ "\n"
  | f in FILES
] ++
[
  "disk " ++ show(d) ++ " used=" ++ show(used[d]) ++
  " load=" ++ show(sum(f in FILES)(Size[f] * bool2int(x[f,d]))) ++ "\n"
  | d in DISKS
];