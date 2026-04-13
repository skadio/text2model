% Parameters
int: NumPorts;                    % Number of port/destination cities (L)
int: NumTerminals;                % Number of terminal/source cities (K)

set of int: K = 1..NumTerminals;  % Index set of terminals
set of int: L = 1..NumPorts;      % Index set of ports/destinations

array[K, L] of int: Cost;         % Transport cost per metric ton from terminal k to destination l
array[L] of int: Demand;          % Demand at destination l
array[K] of int: Supply;          % Supply at terminal k

% Variables
array[K, L] of var int: ShipQty;  % Quantity shipped from terminal k to destination l (metric tons)

% Constraints
% --- Nonnegativity of shipped quantities ---
constraint
  forall(k in K, l in L) (
    ShipQty[k, l] >= 0
  );

% --- Supply limits at each terminal (cannot ship more than available supply) ---
constraint
  forall(k in K) (
    sum(l in L)(ShipQty[k, l]) <= Supply[k]
  );

% --- Demand satisfaction at each destination/port (must meet demand exactly) ---
constraint
  forall(l in L) (
    sum(k in K)(ShipQty[k, l]) = Demand[l]
  );

% Objective
solve minimize sum(k in K, l in L)(Cost[k, l] * ShipQty[k, l]);