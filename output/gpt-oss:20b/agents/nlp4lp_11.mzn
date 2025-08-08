% ------------------------------
% School Assignment – Continuous Flow
% ------------------------------

int: S;          % number of schools
int: G;          % number of student groups (grades)
int: N;          % number of neighborhoods

array[1..S, 1..G] of float: Capacity;      % capacity of school s for group g
array[1..N, 1..G] of float: Population;    % population of group g in neighborhood n
array[1..N, 1..S] of float: Distance;      % distance from neighborhood n to school s

% Decision variables – amount of group g from neighborhood n assigned to school s
array[1..N, 1..G, 1..S] of var float: flow;

% ------------------------------
% Constraints
% ------------------------------

% 1. All students of each group in a neighborhood must be assigned
constraint
  forall(n in 1..N, g in 1..G) (
    sum(s in 1..S) flow[n,g,s] == Population[n,g]
  );

% 2. School capacities per group must not be exceeded
constraint
  forall(s in 1..S, g in 1..G) (
    sum(n in 1..N) flow[n,g,s] <= Capacity[s,g]
  );

% 3. Non‑negative flows
constraint
  forall(n in 1..N, g in 1..G, s in 1..S) (
    flow[n,g,s] >= 0
  );

% ------------------------------
% Objective
% ------------------------------

var float: totalDistance;
constraint
  totalDistance = sum(n in 1..N, g in 1..G, s in 1..S) (
    flow[n,g,s] * Distance[n,s]
  );

solve minimize totalDistance;

% ------------------------------
% Output
% ------------------------------
output [
  "Total distance = ", show(totalDistance), "\n",
  "\n--- Flow assignments (values are continuous) ---\n",
  concat([ show(n) ++ " : " ++
           concat([ show(g) ++ " -> " ++
                    show(s) ++ " = " ++ show(flow[n,g,s]) ++ "; "
                    | s in 1..S]) ++ "\n"
           | n in 1..N ])
];