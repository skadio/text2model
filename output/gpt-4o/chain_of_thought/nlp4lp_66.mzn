% Parameters
int: N;
int: StartCity;                     % Index of the city where the tour starts and ends (1‥N)
array[1..N, 1..N] of int: Distances;

% Variables
array[1..N] of var 1..N: succ;      % succ[i] is the city visited immediately after city i
var int: total_distance;            % total length of the tour

% Constraints
constraint circuit(succ);                                          % single Hamiltonian cycle
constraint total_distance = sum(i in 1..N)(Distances[i, succ[i]]); % compute tour length

% Objective
solve minimize total_distance;