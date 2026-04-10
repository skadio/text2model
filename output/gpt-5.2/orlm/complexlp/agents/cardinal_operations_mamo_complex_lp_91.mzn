% Parameters
int: nCities = 5;                                % number of cities
set of int: Cities = 1..nCities;                 % city indices (1..5)

array[Cities, Cities] of int: cost =             % travel cost matrix
  [|  0, 95, 36, 93, 16
   | 95,  0, 95, 29, 96
   | 36, 95,  0, 72, 38
   | 93, 29, 72,  0, 77
   | 16, 96, 38, 77,  0 |];

% Variables
array[Cities] of var Cities: succ;               % succ[i] = next city visited after city i
array[Cities] of var Cities: pred;               % pred[i] = previous city visited before city i
array[Cities] of var 1..nCities: pos;            % position of each city in the tour (for subtour elimination)

var 0..sum(i,j in Cities)(cost[i,j]): totalCost; % total tour cost (bounded)

% Constraints
% Hamiltonian cycle structure: succ and pred are inverse permutations
constraint
  inverse(succ, pred);

constraint
  % no self-loops (cannot stay in the same city)
  forall(i in Cities) (
    succ[i] != i /\ pred[i] != i
  );

% Single tour enforcement using positions (cycle consistency around the permutation)
constraint
  all_different(pos);

constraint
  % enforce cyclic position increment along successor arcs
  forall(i in Cities) (
    pos[succ[i]] = (pos[i] mod nCities) + 1
  );

% Total cost accumulation from chosen successor arcs
constraint
  totalCost = sum(i in Cities)( cost[i, succ[i]] );

% Objective
solve minimize totalCost;