% ============================================================
% CAPACITATED WAREHOUSE LOCATION PROBLEM
% ============================================================
%
% DESCRIPTION:
% A company must decide which warehouses to open and assign customers to
% these warehouses in order to service all customer demands at minimum cost.
% Each customer has an associated demand, and each warehouse has a limited
% capacity as well as a fixed operating cost if opened. Additionally, if a
% warehouse is opened, it must service at least a minimum amount of demand.
% There are also constraints on the total number of warehouses that can be
% open.
%
% OBJECTIVE:
% Minimize the total cost of serving customers which includes the cost of
% allocating service and the fixed cost of operating the warehouses.
%
% PARAMETERS (provided in input.json):
%   - NumberOfLocations: Total potential warehouse locations.
%   - NumberOfCustomers: Total customers to be serviced.
%   - CustomerDemand: Demand for each customer.
%   - ServiceAllocationCost: Cost matrix for serving each customer from each warehouse.
%   - WarehouseCapacity: Capacity of each warehouse.
%   - MinimumDemandFromWarehouse: Lower limit on demand that must be met if a warehouse is open.
%   - MinimumOpenWarehouses: Minimum number of warehouses that must be open.
%   - MaximumOpenWarehouses: Maximum number of warehouses that can be open.
%   - WarehouseFixedCost: Fixed operating cost for each warehouse.
%
% OUTPUT:
%   - WarehouseOpen: Binary array indicating which warehouses are open.
%   - CustomerAssignment: Binary matrix indicating which warehouse serves each customer.
%   - TotalCost: Total cost of the chosen configuration.
%
% ============================================================


% -----------------------------
% 1) PARAMETERS
% -----------------------------
int: NumberOfLocations;
int: NumberOfCustomers;

array[1..NumberOfCustomers] of int: CustomerDemand;
array[1..NumberOfLocations, 1..NumberOfCustomers] of int: ServiceAllocationCost;
array[1..NumberOfLocations] of int: WarehouseCapacity;
array[1..NumberOfLocations] of int: MinimumDemandFromWarehouse;

int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;
array[1..NumberOfLocations] of int: WarehouseFixedCost;


% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------
% WarehouseOpen[i] = 1 if warehouse i is open, 0 otherwise.
array[1..NumberOfLocations] of var 0..1: WarehouseOpen;

% CustomerAssignment[i,j] = 1 if customer j is assigned to warehouse i, 0 otherwise.
array[1..NumberOfLocations, 1..NumberOfCustomers] of var 0..1: CustomerAssignment;


% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Each customer must be assigned to exactly one warehouse.
constraint
  forall(j in 1..NumberOfCustomers) (
    sum(i in 1..NumberOfLocations)(CustomerAssignment[i,j]) = 1
  );

% (C2) A customer can only be assigned to an open warehouse.
constraint
  forall(i in 1..NumberOfLocations, j in 1..NumberOfCustomers) (
    CustomerAssignment[i,j] <= WarehouseOpen[i]
  );

% (C3) The total demand served by each warehouse cannot exceed its capacity.
constraint
  forall(i in 1..NumberOfLocations) (
    sum(j in 1..NumberOfCustomers)(CustomerDemand[j] * CustomerAssignment[i,j]) <= WarehouseCapacity[i]
  );

% (C4) If a warehouse is open, it must serve at least its minimum demand.
constraint
  forall(i in 1..NumberOfLocations) (
    sum(j in 1..NumberOfCustomers)(CustomerDemand[j] * CustomerAssignment[i,j]) >= MinimumDemandFromWarehouse[i] * WarehouseOpen[i]
  );

% (C5) The total number of open warehouses must be within the allowed limits.
constraint
    sum(i in 1..NumberOfLocations)(WarehouseOpen[i]) >= MinimumOpenWarehouses /\
    sum(i in 1..NumberOfLocations)(WarehouseOpen[i]) <= MaximumOpenWarehouses;


% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------
% TotalCost = Sum(service allocation costs) + Sum(fixed warehouse costs).
var int: TotalCost =
    sum(i in 1..NumberOfLocations, j in 1..NumberOfCustomers)(
         ServiceAllocationCost[i,j] * CustomerDemand[j] * CustomerAssignment[i,j]
    )
  + sum(i in 1..NumberOfLocations)(
         WarehouseFixedCost[i] * WarehouseOpen[i]
    );

solve minimize TotalCost;


% -----------------------------
% 5) OUTPUT
% -----------------------------
output [
    "Warehouse Open: ", show(WarehouseOpen), "\n",
    "Customer Assignment:\n",
    concat([ "  Warehouse " ++ show(i) ++ ": " ++ show([CustomerAssignment[i,j] | j in 1..NumberOfCustomers]) ++ "\n"
             | i in 1..NumberOfLocations ]),
    "Total Cost: ", show(TotalCost), "\n"
];