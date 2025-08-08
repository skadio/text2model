% -----------------------------
%   Transportation problem
% -----------------------------
% Data:
%   NumPorts      : number of destinations (ports)
%   NumTerminals  : number of terminals (sources)
%   Cost          : transportation cost per ton from terminal k to port l
%   Demand        : demand at each destination l
%   Supply        : supply available at each terminal k
%
% Goal: Minimise total transportation cost while satisfying all demands
%       and respecting terminal supplies.

int: NumPorts;
int: NumTerminals;

array[1..NumTerminals] of int: Supply;
array[1..NumPorts]      of int: Demand;
array[1..NumTerminals, 1..NumPorts] of int: Cost;

% ------------------------------------------------------------------
% Variables: quantity shipped from terminal k to port l
% ------------------------------------------------------------------
int: maxSupply = max(Supply);

array[1..NumTerminals, 1..NumPorts] of var 0..maxSupply: x;

% ------------------------------------------------------------------
% Constraints
% ------------------------------------------------------------------
constraint
  % Supply limits: cannot ship more than available at each terminal
  forall(k in 1..NumTerminals) (
    sum(l in 1..NumPorts) x[k,l] <= Supply[k]
  );

constraint
  % Demand satisfaction: each destination must receive at least its demand
  forall(l in 1..NumPorts) (
    sum(k in 1..NumTerminals) x[k,l] >= Demand[l]
  );

% ------------------------------------------------------------------
% Objective: minimise total cost
% ------------------------------------------------------------------
var int: total_cost = sum(k in 1..NumTerminals, l in 1..NumPorts) Cost[k,l] * x[k,l];

solve minimize total_cost;

% ------------------------------------------------------------------
% Output
% ------------------------------------------------------------------
output [
  "Total cost = ", show(total_cost), "\n",
  "Flows (terminal → port):\n",
  concat([ "Terminal ", show(k), ": ",
           show([x[k,l] | l in 1..NumPorts]), "\n"
          | k in 1..NumTerminals ])
];