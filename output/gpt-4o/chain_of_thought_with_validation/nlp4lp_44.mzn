% Parameters
int: N;
float: Capacity;
array[1..N] of float: Size;

set of int: FILES = 1..N;
set of int: DISKS = 1..N;   % Upper-bound on disks (each file on its own disk)

% Variables
array[FILES, DISKS] of var 0..1: x;   % x[i,j] = 1 if file i on disk j
array[DISKS]            of var 0..1: y;   % y[j] = 1 if disk j is used

% Constraints
constraint
    forall(i in FILES) (
        sum(j in DISKS)(x[i,j]) = 1            % each file assigned to exactly one disk
    );

constraint
    forall(j in DISKS) (
        sum(i in FILES)(Size[i] * x[i,j]) <= Capacity * y[j]   % respect disk capacity
    );

% Objective
solve minimize sum(j in DISKS)(y[j]);