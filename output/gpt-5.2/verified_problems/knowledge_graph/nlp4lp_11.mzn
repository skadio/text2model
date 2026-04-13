int: S;
int: G;
int: N;

set of int: SCHOOLS = 1..S;
set of int: GROUPS = 1..G;
set of int: NEIGHBORHOODS = 1..N;

array[SCHOOLS, GROUPS] of float: Capacity;
array[NEIGHBORHOODS, GROUPS] of float: Population;
array[NEIGHBORHOODS, SCHOOLS] of float: Distance;

array[NEIGHBORHOODS, SCHOOLS, GROUPS] of var float: StudentAssignment;

constraint
  forall(n in NEIGHBORHOODS, g in GROUPS) (
    sum(s in SCHOOLS)(StudentAssignment[n,s,g]) = Population[n,g]
  );

constraint
  forall(s in SCHOOLS, g in GROUPS) (
    sum(n in NEIGHBORHOODS)(StudentAssignment[n,s,g]) <= Capacity[s,g]
  );

constraint
  forall(n in NEIGHBORHOODS, s in SCHOOLS, g in GROUPS) (
    StudentAssignment[n,s,g] >= 0.0
  );

var float: TotalDistance =
  sum(n in NEIGHBORHOODS, s in SCHOOLS, g in GROUPS)(
    StudentAssignment[n,s,g] * Distance[n,s]
  );

solve minimize TotalDistance;

output [
  "TotalDistance=", show(TotalDistance), "\n",
  "StudentAssignment[n,s,g]=\n",
  show(StudentAssignment), "\n"
];