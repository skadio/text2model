% Parameters
int: N; % Number of files
int: Capacity; % Total capacity of a floppy disk
array[1..N] of int: Size; % Size of each file

% Variables
array[1..N] of var 0..N: Disk; % Disk assigned to each file
var 0..N: NumDisks; % Total number of disks used

% Constraints
constraint forall(i in 1..N)(sum(j in 1..N)(if Disk[j] = i then Size[j] else 0 endif) <= Capacity);
constraint forall(i in 1..N)(Disk[i] <= NumDisks);

% Objective
solve minimize NumDisks;

% Output
output ["Number of disks used: ", show(NumDisks), "\n"] ++
["Disk assignments: "] ++ [if fix(Disk[i]) = j then "File " ++ show(i) ++ " is on disk " ++ show(j) ++ "\n" else "" endif | i in 1..N, j in 1..N];