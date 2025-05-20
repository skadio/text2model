% Parameters
int: NumberOfLocations;
int: NumberOfCustomers;

set of int: LOC  = 1..NumberOfLocations;
set of int: CUST = 1..NumberOfCustomers;

array[LOC]  of int: WarehouseCapacity;
array[LOC]  of int: MinimumDemandFromWarehouse;
array[LOC]  of int: WarehouseFixedCost;

array[CUST] of int: CustomerDemand;
array[LOC, CUST] of int: ServiceAllocationCost;

int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;

% Variables
array[LOC]        of var 0..1: Open;                     % 1 if warehouse i is opened
array[LOC, CUST]  of var 0..1: Assign;                   % 1 if customer j served by warehouse i

% Constraints
constraint
    forall (j in CUST) (
        sum (i in LOC) (Assign[i,j]) = 1                 % every customer assigned exactly once
    );

constraint
    forall (i in LOC, j in CUST) (
        Assign[i,j] <= Open[i]                           % only open warehouses can serve
    );

constraint
    forall (i in LOC) (
        sum (j in CUST) (CustomerDemand[j] * Assign[i,j]) <= WarehouseCapacity[i]  % capacity upper bound
    );

constraint
    forall (i in LOC) (
        sum (j in CUST) (CustomerDemand[j] * Assign[i,j]) >= 
            MinimumDemandFromWarehouse[i] * Open[i]                            % minimum served if opened
    );

constraint
    let { var int: NumOpen = sum (i in LOC) (Open[i]) } in
        (NumOpen >= MinimumOpenWarehouses /\ NumOpen <= MaximumOpenWarehouses); % bounds on number of open warehouses

% Objective
solve minimize
    sum (i in LOC, j in CUST) (ServiceAllocationCost[i,j] * Assign[i,j]) +
    sum (i in LOC) (WarehouseFixedCost[i] * Open[i]);