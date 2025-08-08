int: N;
int: StartCity; % 0‑based index of the starting city
array[1..N, 1..N] of int: Distances;

int: startIndex = StartCity + 1; % convert to 1‑based index

array[1..N, 1..N] of var bool: x; % x[i,j] = 1 if the tour goes from i to j

% No self loops
constraint
  forall(i in 1..N) x[i,i] = false;

% Each city has exactly one outgoing and one incoming edge
constraint
  forall(i in 1..N) (
    sum(j in 1..N where j != i) x[i,j] = 1
  ) /\
  forall(j in 1..N) (
    sum(i in 1..N where i != j) x[i,j] = 1
  );

% Subtour elimination (Miller–Tucker–Zemlin)
array[1..N] of var 0..N: u; % position of city in the tour
constraint
  forall(i in 1..N where i != startIndex) (
    u[i] >= 1 /\ u[i] <= N-1
  );
constraint
  forall(i in 1..N where i != startIndex) (
    forall(j in 1..N where j != i /\ j != startIndex) (
      u[i] - u[j] + (N-1) * x[i,j] <= N-2
    )
  );

% Objective: minimize total travel distance
var int: totalDist = sum(i in 1..N, j in 1..N where i != j) x[i,j] * Distances[i,j];
solve minimize totalDist;

output [
  "Total distance: ", show(totalDist), "\n"
];