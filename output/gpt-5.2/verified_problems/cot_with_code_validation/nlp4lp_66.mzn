% Traveling Salesman Problem (symmetric), start and return to StartCity

% Parameters
int: N;
int: StartCity;                 % expected 0-based in data; converted below
array[1..N, 1..N] of int: Distances;

set of int: Cities = 1..N;

% Convert 0-based StartCity to 1-based index used in this model
int: Start = StartCity + 1;

% Variables
array[Cities] of var Cities: succ;
var int: total_distance;

% Constraints
constraint Start in Cities;

% Optional consistency checks for symmetric TSP instances
constraint forall(i in Cities) (Distances[i,i] = 0);
constraint forall(i,j in Cities where i < j) (Distances[i,j] = Distances[j,i]);

% One Hamiltonian cycle
constraint circuit(succ);

% Break rotational symmetry: fix successor of the start city
constraint succ[Start] < Start;

% Total distance
constraint total_distance = sum(i in Cities)(Distances[i, succ[i]]);

% Objective
solve minimize total_distance;

% Output
output [
  "total_distance = ", show(total_distance), "\n",
  "succ = ", show(succ), "\n"
];