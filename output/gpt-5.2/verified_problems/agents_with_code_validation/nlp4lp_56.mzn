% Transportation problem: ship from terminals to ports/destinations at minimum cost

% Parameters
int: NumPorts;                      % number of ports/destinations (L)
int: NumTerminals;                  % number of terminals/sources (K)

set of int: K = 1..NumTerminals;
set of int: L = 1..NumPorts;

array[K, L] of int: Cost;           % Cost[k,l]
array[L] of int: Demand;            % Demand[l]
array[K] of int: Supply;            % Supply[k]

% Decision variables (use finite bounds to avoid slow/unstable compilation/solving)
int: TotalSupply = sum(k in K)(Supply[k]);
array[K, L] of var 0..TotalSupply: Flow;

% Constraints
constraint forall(l in L)(
  sum(k in K)(Flow[k,l]) = Demand[l]
);

constraint forall(k in K)(
  sum(l in L)(Flow[k,l]) <= Supply[k]
);

% Objective
solve minimize sum(k in K, l in L)(Cost[k,l] * Flow[k,l]);