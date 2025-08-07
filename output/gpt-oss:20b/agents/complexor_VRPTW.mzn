%  Vehicle Routing Problem with Time Windows (VRPTW)
%  -------------------------------------------------
%  The data file (.dzn) must provide the following variables:
%
%    int:           CustomerCount;       % number of customers
%    int:           VehicleCount;        % number of vehicles
%    array[1..CustomerCount] of int: CustomerDemand;
%    array[1..CustomerCount] of int: CustomerLBTW;   % lower time window
%    array[1..CustomerCount] of int: CustomerUBTW;   % upper time window
%    array[1..CustomerCount, 1..CustomerCount] of int: CustomerDistance;
%    array[1..CustomerCount] of int: CustomerServiceTime;
%    array[1..VehicleCount] of int: VehicleCapacity;
%
%  All time values are assumed to be in the same unit (e.g. minutes).

include "globals.mzn";

% -------------- Basic data ---------------------------------
int: N = CustomerCount;      % number of customers
int: M = VehicleCount;       % number of vehicles

% -------------- Extend data with depot (index 0) ------------
array[0..N,0..N] of int: dist = 
  [| 
    [ if i==0 \/ j==0 then 0 else CustomerDistance[i][j] endif | j in 0..N] 
  | i in 0..N];

array[0..N] of int: serv =
  [ if i==0 then 0 else CustomerServiceTime[i] endif | i in 0..N];

% -------------- Variables ----------------------------------
array[0..N,0..N,1..M] of var bool: arc;           % arc[i][j][k] = 1 if vehicle k goes i -> j
array[1..N,1..M] of var bool: visited;            % visited[i][k] = 1 if customer i served by vehicle k
array[0..N,1..M] of var 0..N: u;                 % position of node i in the route of vehicle k
array[0..N,1..M] of var 0..max(CustomerUBTW)+max(dist)+max(serv): t;  % arrival time at node i by vehicle k

% -------------- Vehicle start / end constraints -----------
constraint forall(k in 1..M) (
  sum(j in 0..N) arc[0][j][k] == 1 /\          % one outgoing arc from depot
  sum(i in 0..N) arc[i][0][k] == 1             % one incoming arc to depot
);

% -------------- Each customer is visited exactly once ---
constraint forall(i in 1..N) (
  sum(k in 1..M, j in 0..N) arc[i][j][k] == 1 /\   % one outgoing arc
  sum(k in 1..M, j in 0..N) arc[j][i][k] == 1      % one incoming arc
);

% -------------- Link visited flag with arcs ---------------
constraint forall(i in 1..N, k in 1..M) (
  visited[i][k] = (sum(j in 0..N) arc[j][i][k] == 1)
);

% -------------- Capacity constraints ----------------------
constraint forall(k in 1..M) (
  sum(i in 1..N) CustomerDemand[i] * (if visited[i][k] then 1 else 0) <= VehicleCapacity[k]
);

% -------------- MTZ constraints to eliminate sub‑cycles ----
%    depot position fixed to 0
constraint forall(k in 1..M) ( u[0][k] == 0 );

%    strictly increasing positions along travelled arcs
constraint forall(k in 1..M, i in 1..N, j in 1..N where i != j) (
  arc[i][j][k] -> u[j][k] == u[i][k] + 1
);

%    positions are bounded
constraint forall(k in 1..M, i in 1..N) ( u[i][k] <= N );

% -------------- Time‑window constraints --------------------
%    time at depot is zero
constraint forall(k in 1..M) ( t[0][k] == 0 );

%    time windows for customers that are visited
constraint forall(i in 1..N, k in 1..M) (
  visited[i][k] -> 
    t[i][k] >= CustomerLBTW[i] /\ 
    t[i][k] <= CustomerUBTW[i]
);

%    travel time between consecutive nodes
constraint forall(k in 1..M, i in 0..N, j in 1..N where i != j) (
  arc[i][j][k] ->
    t[j][k] >= t[i][k] + dist[i][j] + serv[i]
);

% -------------- Objective ----------------------------------
var int: totalCost = sum(k in 1..M, i in 0..N, j in 0..N) (
  if arc[i][j][k] then dist[i][j] else 0 endif
);

solve minimize totalCost;

% -------------- Output ------------------------------------
output [
  "Total Cost = ", show(totalCost), "\n",
  "Route for each vehicle:\n",
  concat([ "Vehicle ", show(k), ": ", 
           show([ j | i in 0..N, j in 0..N where arc[i][j][k] ]), "\n"
         | k in 1..M ])
];