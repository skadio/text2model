% Parameters (match data.dzn)
int: N;
float: Capacity;
array[1..N] of float: Size;

% Upper bound: one disk per file
int: U = N;

% Decision variables
array[1..U, 1..N] of var bool: x;     % x[d,j] = true if file j is placed on disk d
array[1..U] of var bool: used;        % used[d] = true if disk d is used

% Each file assigned to exactly one disk
constraint
  forall(j in 1..N) (
    sum(d in 1..U)(bool2int(x[d,j])) = 1
  );

% Capacity constraint per disk
constraint
  forall(d in 1..U) (
    sum(j in 1..N)(Size[j] * bool2int(x[d,j])) <= Capacity * bool2int(used[d])
  );

% If a file is on disk d, then disk d is used
constraint
  forall(d in 1..U, j in 1..N) (
    bool2int(x[d,j]) <= bool2int(used[d])
  );

% Symmetry breaking: use earlier disks first
constraint
  forall(d in 1..U-1) (
    bool2int(used[d]) >= bool2int(used[d+1])
  );

% Objective: minimize number of disks used
solve minimize sum(d in 1..U)(bool2int(used[d]));