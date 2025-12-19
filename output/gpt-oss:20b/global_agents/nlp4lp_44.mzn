include "globals.mzn";

int: N;                     % number of files
float: capacity;            % capacity of one floppy disk
array[1..N] of float: size; % size of each file

% Assignment of each file to a disk (1..N)
array[1..N] of var 1..N: bin;

% Number of disks that will actually be used
var 1..N: used_bins;

% The maximum bin index used must be <= used_bins
constraint forall(i in 1..N)( bin[i] <= used_bins );

% Capacity constraint for each disk
constraint forall(b in 1..N)(
    sum(i in 1..N)( bool2int(bin[i] == b) * size[i] ) <= capacity
);

solve minimize used_bins;

output [
  "Used bins = ", show(used_bins), "\n",
  "Assignments = ", show(bin), "\n"
];