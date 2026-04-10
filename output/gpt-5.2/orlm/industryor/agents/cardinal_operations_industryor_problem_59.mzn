% Parameters
int: n = 7;                           % number of locations (customers), indexed 1..7
set of int: LOC = 1..n;               % set of locations
int: start = 1;                       % start/end location

% Symmetric distance matrix (diagonal set to 0)
array[LOC, LOC] of int: dist =
  [|  0, 86, 49, 57, 31, 69, 50
   | 86,  0, 68, 79, 93, 24,  5
   | 49, 68,  0, 16,  7, 72, 67
   | 57, 79, 16,  0, 90, 69,  1
   | 31, 93,  7, 90,  0, 86, 59
   | 69, 24, 72, 69, 86,  0, 81
   | 50,  5, 67,  1, 59, 81,  0 |];

% Upper bound for total tour length (safe bound using max arc length)
int: maxDist = max([dist[i,j] | i in LOC, j in LOC]);
int: obj_ub = n * maxDist;

% Variables
array[LOC, LOC] of var 0..1: x;       % x[i,j]=1 if tour goes directly from i to j (directed arcs)
array[LOC] of var 0..n-1: u;           % MTZ ordering variables for subtour elimination
var 0..obj_ub: total_distance;         % total travel distance (objective)

% Constraints

% --- Tour structure: no self-loops ---
constraint
  forall(i in LOC) (
    x[i,i] = 0
  );

% --- Exactly one outgoing arc from each location ---
constraint
  forall(i in LOC) (
    sum(j in LOC)(x[i,j]) = 1
  );

% --- Exactly one incoming arc to each location ---
constraint
  forall(j in LOC) (
    sum(i in LOC)(x[i,j]) = 1
  );

% --- Fix start/end handling: ensure location 'start' is part of the single Hamiltonian cycle ---
% (Already implied by in/out degree constraints; keep MTZ anchors consistent.)
constraint
  u[start] = 0;

% --- MTZ variable domains/anchors for non-start nodes (tighten to improve propagation) ---
constraint
  forall(i in LOC where i != start) (
    u[i] >= 1 /\ u[i] <= n - 1
  );

% --- Subtour elimination (MTZ) ---
% If arc i->j is chosen (and neither is start), then u[j] must be after u[i].
constraint
  forall(i in LOC, j in LOC where i != j /\ i != start /\ j != start) (
    u[i] - u[j] + (n - 1) * x[i,j] <= n - 2
  );

% --- Total distance definition ---
constraint
  total_distance =
    sum(i in LOC, j in LOC)(
      dist[i,j] * x[i,j]
    );

% Objective
solve minimize total_distance;