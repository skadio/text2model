include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: P;                                % number of warehouses to open
int: num_customers;
int: num_warehouses;

array[1..num_customers] of float: Demand;
array[1..num_customers, 1..num_warehouses] of float: Distance;

%----------------------------
% Decision variables
%----------------------------
array[1..num_warehouses] of var 0..1: open;                 % 1 if warehouse j is opened
array[1..num_customers] of var 1..num_warehouses: serve;    % warehouse serving customer i

%----------------------------
% Constraints
%----------------------------
% Open exactly P warehouses (hint)
constraint count(open, 1, P);

% Each customer must be assigned to an open warehouse
constraint forall(i in 1..num_customers)(
  open[serve[i]] = 1
);

%----------------------------
% Objective: minimize demand-weighted distance
%----------------------------
var float: total_cost =
  sum(i in 1..num_customers)(
    Demand[i] * Distance[i, serve[i]]
  );

solve minimize total_cost;

%----------------------------
% Output
%----------------------------
output [
  "total_cost = ", show(total_cost), "\n",
  "open = ", show(open), "\n",
  "serve = ", show(serve), "\n"
];