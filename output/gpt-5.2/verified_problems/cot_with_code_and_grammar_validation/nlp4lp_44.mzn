% Parameters
int: N;
float: Capacity;
array[1..N] of float: Size;

% Variables
int: M = N; % upper bound on number of disks used
array[1..N, 1..M] of var bool: x; % x[j,d] = 1 if file j is placed on disk d
array[1..M] of var bool: y;       % y[d] = 1 if disk d is used

% Constraints
constraint forall(j in 1..N)(
  sum(d in 1..M)(bool2int(x[j,d])) = 1
);

constraint forall(d in 1..M)(
  sum(j in 1..N)(Size[j] * bool2int(x[j,d])) <= Capacity * bool2int(y[d])
);

constraint forall(j in 1..N, d in 1..M)(
  x[j,d] -> y[d]
);

% Objective
solve minimize sum(d in 1..M)(bool2int(y[d]));