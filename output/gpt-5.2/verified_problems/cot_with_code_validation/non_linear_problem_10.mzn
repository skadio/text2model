% Department location / relocation with communication costs

% Parameters
int: ndepts;
int: ncities;
int: ncitiesm1; % (not used in this model, but kept for data compatibility)

array[1..ndepts, 1..ncities] of int: benefit;
array[1..ncities, 1..ncities] of int: dist;
array[1..ndepts, 1..ndepts] of int: comm;

% Decision variables: x[d,c] = 1 iff department d is located in city c
array[1..ndepts, 1..ncities] of var 0..1: x;

% Each department in exactly one city
constraint forall(d in 1..ndepts) (
  sum(c in 1..ncities)(x[d,c]) = 1
);

% Capacity: at most 3 departments per city
constraint forall(c in 1..ncities) (
  sum(d in 1..ndepts)(x[d,c]) <= 3
);

% Objective components (use var int with defining constraints)
var int: total_benefit =
  sum(d in 1..ndepts, c in 1..ncities)(benefit[d,c] * x[d,c]);

% Communication cost between departments based on their assigned cities
% Sum only over d1<d2 to avoid double-counting (assumes comm/dist symmetric or intended undirected cost)
var int: total_comm_cost =
  sum(d1 in 1..ndepts, d2 in d1+1..ndepts,
      c1 in 1..ncities, c2 in 1..ncities)(
    comm[d1,d2] * dist[c1,c2] * (x[d1,c1] * x[d2,c2])
  );

solve maximize total_benefit - total_comm_cost;