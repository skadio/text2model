% Parameters
int: N;                                               % Number of files
float: Capacity;                                      % Capacity of one floppy disk
array[1..N] of float: Size;                           % Size of each file

set of int: FILES = 1..N;                             % Index set for files
set of int: DISKS = 1..N;                             % Upper bound on number of disks (one per file)

% Variables
array[DISKS] of var 0..1: y;                          % y[k] = 1 if disk k is used
array[FILES, DISKS] of var 0..1: x;                   % x[j,k] = 1 if file j is placed on disk k

% Constraints
% 1) Every file is assigned to exactly one disk
constraint
    forall(j in FILES) (
        sum(k in DISKS)( x[j,k] ) = 1
    );

% 2) Linking assignment to disk usage
constraint
    forall(j in FILES, k in DISKS) (
        x[j,k] <= y[k]
    );

% 3) Capacity constraint for each disk
constraint
    forall(k in DISKS) (
        sum(j in FILES)( Size[j] * int2float(x[j,k]) ) <= Capacity * int2float(y[k])
    );

% 4) Symmetry breaking: used disks appear first
constraint
    forall(k in 1..N-1) (
        y[k] >= y[k+1]
    );

% Objective
solve minimize sum(k in DISKS)( y[k] );