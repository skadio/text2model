% Parameters
int: OriginNum;                           % number of origins
int: DestinationNum;                      % number of destinations

set of int: ORIGINS = 1..OriginNum;       % index set for origins
set of int: DESTS   = 1..DestinationNum;  % index set for destinations

array[ORIGINS] of int: Supply;            % supply available at each origin
array[DESTS]   of int: Demand;            % demand required at each destination
array[ORIGINS, DESTS] of int: Cost;       % per-unit transport cost from origin to destination


% Variables
array[ORIGINS, DESTS] of var int: Ship;   % units shipped from origin i to destination j


% Constraints
% --- Nonnegativity and simple per-lane upper bounds ---
constraint forall(i in ORIGINS, j in DESTS) (Ship[i,j] >= 0);

% Optional tight upper bounds (as constraints)
constraint forall(i in ORIGINS, j in DESTS) (Ship[i,j] <= Supply[i]);
constraint forall(i in ORIGINS, j in DESTS) (Ship[i,j] <= Demand[j]);

% --- Demand satisfaction: each destination's incoming shipments meet demand exactly ---
constraint forall(j in DESTS) (
  sum(i in ORIGINS)(Ship[i,j]) = Demand[j]
);

% --- Supply limits: total outgoing shipments from each origin do not exceed supply ---
constraint forall(i in ORIGINS) (
  sum(j in DESTS)(Ship[i,j]) <= Supply[i]
);


% Objective
solve minimize sum(i in ORIGINS, j in DESTS)(Cost[i,j] * Ship[i,j]);