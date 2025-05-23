% Parameters
int: N;
float: Capacity;
array[1..N] of float: Size;

set of int: FILES = 1..N;
set of int: DISKS = 1..N;   % Worst-case upper bound on disks needed

% Variables
array[FILES, DISKS] of var 0..1: x;   % 1 if file i is stored on disk b
array[DISKS] of var 0..1: y;          % 1 if disk b is used

% Constraints
%
% Each file must be placed on exactly one disk
constraint
  forall(i in FILES)(
    sum(b in DISKS)(x[i,b]) = 1
  );

% A file can only be placed on a disk that is declared “used”
constraint
  forall(i in FILES, b in DISKS)(
    x[i,b] <= y[b]
  );

% Capacity limits for every disk
constraint
  forall(b in DISKS)(
    sum(i in FILES)(Size[i] * int2float(x[i,b])) <= Capacity * int2float(y[b])
  );

% Symmetry-breaking: use lower-indexed disks first
constraint
  forall(b in 1..N-1)(
    y[b] >= y[b+1]
  );

% Objective
solve minimize sum(b in DISKS)(y[b]);