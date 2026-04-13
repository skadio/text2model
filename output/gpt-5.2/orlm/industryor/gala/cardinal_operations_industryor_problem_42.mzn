% Transportation planning / integer linear optimization
% Data embedded as requested.

include "globals.mzn";

% Demand (minimum required)
int: reqA = 240;   % pieces of raw material A
int: reqB = 80;    % kg of raw material B
int: reqC = 120;   % tons of raw material C

% Per-truck supply and cost
int: aA = 4;  int: aB = 2;  int: aC = 6;  int: costA = 200;  % Warehouse A truck
int: bA = 7;  int: bB = 2;  int: bC = 2;  int: costB = 160;  % Warehouse B truck

% Decision variables: number of trucks from each warehouse (nonnegative integers)
% Simple safe upper bounds derived from meeting each demand with a single warehouse.
int: ubA = max( (reqA + aA - 1) div aA, max((reqB + aB - 1) div aB, (reqC + aC - 1) div aC) );
int: ubB = max( (reqA + bA - 1) div bA, max((reqB + bB - 1) div bB, (reqC + bC - 1) div bC) );

var 0..ubA: xA;  % trucks from warehouse A
var 0..ubB: xB;  % trucks from warehouse B

% Demand satisfaction constraints
constraint aA*xA + bA*xB >= reqA;
constraint aB*xA + bB*xB >= reqB;
constraint aC*xA + bC*xB >= reqC;

% Objective: minimize total cost
var int: totalCost = costA*xA + costB*xB;
solve minimize totalCost;

output [
  "Trucks from A = ", show(xA), "\n",
  "Trucks from B = ", show(xB), "\n",
  "Total cost    = ", show(totalCost), " yuan\n",
  "Delivered A   = ", show(aA*xA + bA*xB), " pieces\n",
  "Delivered B   = ", show(aB*xA + bB*xB), " kg\n",
  "Delivered C   = ", show(aC*xA + bC*xB), " tons\n"
];