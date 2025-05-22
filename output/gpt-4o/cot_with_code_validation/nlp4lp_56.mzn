% Parameters
int: NumPorts;
int: NumTerminals;

set of int: K = 1..NumTerminals;          % Terminals
set of int: L = 1..NumPorts;             % Ports / Destinations

array[K, L] of int: Cost;                % Transportation cost from terminal k to port l
array[K] of int: Supply;                 % Supply at each terminal k
array[L] of int: Demand;                 % Demand at each port l

int: TotalSupply = sum(k in K)(Supply[k]);

% Variables
array[K, L] of var 0..TotalSupply: X;    % Quantity shipped from terminal k to port l

% Constraints
constraint
  forall(k in K)(
    sum(l in L)(X[k,l]) <= Supply[k]     % Do not exceed supply at each terminal
  );

constraint
  forall(l in L)(
    sum(k in K)(X[k,l]) >= Demand[l]     % Satisfy demand at each port
  );

% Objective
solve minimize
  sum(k in K, l in L)(Cost[k,l] * X[k,l]);