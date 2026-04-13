int: S;
int: G;
int: N;

array[1..S, 1..G] of float: Capacity;
array[1..N, 1..G] of float: Population;
array[1..N, 1..S] of float: Distance;

array[1..N, 1..S, 1..G] of var float: Assign;

var float: TotalDistance;

constraint forall(n in 1..N, s in 1..S, g in 1..G) (
  Assign[n,s,g] >= 0.0
);

constraint forall(n in 1..N, g in 1..G) (
  sum(s in 1..S)(Assign[n,s,g]) = Population[n,g]
);

constraint forall(s in 1..S, g in 1..G) (
  sum(n in 1..N)(Assign[n,s,g]) <= Capacity[s,g]
);

constraint
  TotalDistance =
    sum(n in 1..N, s in 1..S, g in 1..G) (
      Assign[n,s,g] * Distance[n,s]
    );

solve minimize TotalDistance;