% ============================================================
% GOODS TRANSPORTATION OPTIMIZATION MODEL
% ============================================================
%
% DESCRIPTION:
%  Efficiently allocate goods from a set of origins to a set of destinations.
%  Each origin i has a fixed supply, and each destination j has a fixed demand.
%  There is a cost associated with transporting goods from origin i to destination j.
%  The objective is to minimize the total transportation cost while meeting all
%  customer demands and not exceeding the supplies at the origins.
%
% PARAMETERS (provided via input.json or a data file):
%   - OriginNum: Total number of origins.
%   - DestinationNum: Total number of destinations.
%   - Supply: An array of length OriginNum, where Supply[i] is the supply at origin i.
%   - Demand: An array of length DestinationNum, where Demand[j] is the demand at destination j.
%   - Cost: A matrix (OriginNum x DestinationNum) where Cost[i,j] is the transportation cost
%           from origin i to destination j.
%
% OUTPUT:
%   - ShippingPlan: A matrix (OriginNum x DestinationNum) indicating the quantity shipped
%                   from each origin to each destination.
%   - TotalCost: The total transportation cost.
%
% ============================================================

% -----------------------------
% 1) PARAMETERS
% -----------------------------
int: OriginNum;
int: DestinationNum;

array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

% An upper bound on shipment quantity for each cell.
% A safe uniform upper bound is the maximum supply among all origins.
int: U = max(Supply);

% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------
% ShippingPlan[i,j] represents the quantity shipped from origin i to destination j.
array[1..OriginNum, 1..DestinationNum] of var 0..U: ShippingPlan;

% TotalCost: The overall transportation cost.
var int: TotalCost = sum(i in 1..OriginNum, j in 1..DestinationNum)(Cost[i,j] * ShippingPlan[i,j]);

% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) For each origin, the total shipment cannot exceed its supply.
constraint
  forall(i in 1..OriginNum) (
    sum(j in 1..DestinationNum)(ShippingPlan[i,j]) <= Supply[i]
  );

% (C2) For each destination, the total shipment must exactly meet its demand.
constraint
  forall(j in 1..DestinationNum) (
    sum(i in 1..OriginNum)(ShippingPlan[i,j]) = Demand[j]
  );

% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------
% Minimize the total transportation cost.
solve minimize TotalCost;

% -----------------------------
% 5) OUTPUT
% -----------------------------
output [
  "Shipping Plan:\n",
  concat([
    "Origin " ++ show(i) ++ ": " ++ show([ShippingPlan[i,j] | j in 1..DestinationNum]) ++ "\n"
    | i in 1..OriginNum
  ]),
  "Total Cost: ", show(TotalCost), "\n"
];