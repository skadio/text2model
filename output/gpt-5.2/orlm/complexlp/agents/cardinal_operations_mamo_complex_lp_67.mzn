% Parameters
int: nWarehouses = 5;                              % Number of warehouses (A..E)
set of int: W = 1..nWarehouses;                    % Warehouse indices

array[W, W] of int: travelCost =                   % Travel cost matrix
  [|  0, 15, 88, 54, 92
   | 15,  0, 29, 98, 33
   | 88, 29,  0, 96, 96
   | 54, 98, 96,  0, 63
   | 92, 33, 96, 63,  0 |];

% Variables
array[W] of var W: nextWarehouse;                  % nextWarehouse[i] = warehouse visited after i
var W: startWarehouse;                             % Starting (and ending) warehouse
array[W] of var 1..nWarehouses: visitOrder;        % Visit positions (for subtour elimination)

var 0..sum(i in W, j in W)(travelCost[i,j]): totalCost;  % Total travel cost (bounded)

% Constraints

% --- Hamiltonian tour structure: exactly one successor and one predecessor ---
constraint
  circuit(nextWarehouse);  % Ensures a single cycle visiting every warehouse exactly once

% --- Start warehouse is a valid warehouse index ---
constraint
  startWarehouse in W;

% --- Visit order / subtour-elimination linking (MTZ-style) ---
% Fix the start warehouse to be position 1 in the visit order
constraint
  visitOrder[startWarehouse] = 1;

% Enforce consistent ordering along each selected arc, except for arcs entering the start node
constraint
  forall(i in W where i != startWarehouse) (
    forall(j in W where j != startWarehouse) (
      (nextWarehouse[i] = j) -> (visitOrder[j] = visitOrder[i] + 1)
    )
  );

% --- Total cost computation (including return via the circuit) ---
constraint
  totalCost = sum(i in W)( travelCost[i, nextWarehouse[i]] );

% Objective
solve minimize totalCost;