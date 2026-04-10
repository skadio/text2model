% Parameters
int: N;
float: Capacity;
array[1..N] of float: Size;

% Variables
int: U = N; % upper bound on disks used
array[1..U] of var bool: use;
array[1..U, 1..N] of var bool: x; % x[d,j]=1 if file j is placed on disk d

% Constraints
constraint forall(j in 1..N)(
  sum(d in 1..U)(bool2int(x[d,j])) = 1
);

constraint forall(d in 1..U)(
  sum(j in 1..N)(Size[j] * bool2int(x[d,j])) <= Capacity * bool2int(use[d])
);

constraint forall(d in 1..U, j in 1..N)(
  x[d,j] -> use[d]
);

% Objective
solve minimize sum(d in 1..U)(bool2int(use[d]));