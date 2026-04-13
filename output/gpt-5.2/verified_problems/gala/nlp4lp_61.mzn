include "globals.mzn";

%========================
% Input data (from .dzn)
%========================
int: T;
array[1..T] of int: Demands;
array[1..T] of int: UnloadCosts;
array[1..T] of int: UnloadCapacity;

int: HoldingCost;
int: MaxContainer;
int: InitContainer;

int: NumCranes;
int: CraneCapacity;
int: CraneCost;

%========================
% Decision variables
%========================
array[1..T] of var 0..max(UnloadCapacity): unload;     % containers unloaded from rail in month t
array[1..T] of var 0..MaxContainer: inv;               % inventory at end of month t
array[1..T] of var 0..NumCranes: cranes;               % cranes rented in month t

%========================
% Constraints
%========================

% Inventory balance:
% inv[t] = inv[t-1] + unload[t] - Demands[t]
constraint inv[1] = InitContainer + unload[1] - Demands[1];
constraint forall(t in 2..T)(
  inv[t] = inv[t-1] + unload[t] - Demands[t]
);

% Storage capacity already enforced by inv domain 0..MaxContainer

% Unloading capacity per month
constraint forall(t in 1..T)(
  unload[t] <= UnloadCapacity[t]
);

% Crane loading capacity must cover demand each month (loading is exactly demand)
constraint forall(t in 1..T)(
  cranes[t] * CraneCapacity >= Demands[t]
);

% No containers after the final month
constraint inv[T] = 0;

%========================
% Objective: minimize total cost
%========================
var int: total_unload_cost  = sum(t in 1..T)(unload[t] * UnloadCosts[t]);
var int: total_holding_cost = sum(t in 1..T-1)(inv[t] * HoldingCost); % held into next month
var int: total_crane_cost   = sum(t in 1..T)(cranes[t] * CraneCost);

var int: total_cost = total_unload_cost + total_holding_cost + total_crane_cost;

solve minimize total_cost;

%========================
% Output
%========================
output [
  "unload = ", show(unload), "\n",
  "inv    = ", show(inv), "\n",
  "cranes = ", show(cranes), "\n",
  "total_unload_cost  = ", show(total_unload_cost), "\n",
  "total_holding_cost = ", show(total_holding_cost), "\n",
  "total_crane_cost   = ", show(total_crane_cost), "\n",
  "total_cost         = ", show(total_cost), "\n"
];