% Parameters
int: OriginNum;                          % total number of origins
int: DestinationNum;                     % total number of destinations

set of int: ORIGINS = 1..OriginNum;      % index set for origins
set of int: DESTS   = 1..DestinationNum; % index set for destinations

array[ORIGINS] of int: Supply;           % supply available at each origin
array[DESTS]   of int: Demand;           % demand required at each destination
array[ORIGINS, DESTS] of int: Cost;      % unit transportation cost from origin to destination

% Variables
array[ORIGINS, DESTS] of var int: Ship;  % units shipped from origin i to destination j

% Constraints
% Non-negativity of shipments
constraint forall(i in ORIGINS, j in DESTS) (Ship[i,j] >= 0);

% Destination demand satisfaction: each destination must receive exactly its demand
constraint
  forall(j in DESTS) (
    sum(i in ORIGINS)(Ship[i,j]) = Demand[j]
  );

% Origin supply limits: total shipped out of each origin cannot exceed its supply
constraint
  forall(i in ORIGINS) (
    sum(j in DESTS)(Ship[i,j]) <= Supply[i]
  );

% Objective
solve minimize sum(i in ORIGINS, j in DESTS)(Cost[i,j] * Ship[i,j]);