% Parameters
int: T;                                 % number of time periods (months)
set of int: TIME = 1..T;                % index set for months

array[TIME] of int: Demands;            % demand (containers needed by ships) in month t
array[TIME] of int: UnloadCosts;        % unloading cost per container in month t
array[TIME] of int: UnloadCapacity;     % maximum containers that can be unloaded in month t

int: HoldingCost;                       % holding cost per container carried to next month
int: MaxContainer;                      % max containers allowed in yard at end of any month
int: InitContainer;                     % initial containers in yard at start of month 1

int: NumCranes;                         % maximum number of cranes that can be rented each month
int: CraneCapacity;                     % containers loaded per crane per month
int: CraneCost;                         % cost to rent one crane for a month


% Variables
array[TIME] of var 0..max(UnloadCapacity): Unloaded;        % containers unloaded from rail in month t
array[TIME] of var 0..MaxContainer: InventoryEnd;           % containers in yard at end of month t
array[TIME] of var 0..NumCranes: CranesRented;              % number of cranes rented in month t
array[TIME] of var 0..(NumCranes * CraneCapacity): Loaded;  % containers loaded onto ships in month t


% Constraints
%--- Inventory flow balance (containers in yard) ---
% Inventory at end of month 1: initial + unloaded - loaded
constraint
  InventoryEnd[1] = InitContainer + Unloaded[1] - Loaded[1];

% Inventory at end of month t (t>=2): previous inventory + unloaded - loaded
constraint
  forall(t in 2..T) (
    InventoryEnd[t] = InventoryEnd[t-1] + Unloaded[t] - Loaded[t]
  );

%--- Demand fulfillment ---
% Each month's ship demand must be met by loaded containers
constraint
  forall(t in TIME) (
    Loaded[t] = Demands[t]
  );

%--- Unloading capacity limits ---
constraint
  forall(t in TIME) (
    Unloaded[t] <= UnloadCapacity[t]
  );

%--- Yard storage capacity limits ---
% (Also implied by variable domain 0..MaxContainer; kept for clarity)
constraint
  forall(t in TIME) (
    InventoryEnd[t] <= MaxContainer
  );

%--- End-of-horizon condition ---
constraint
  InventoryEnd[T] = 0;

%--- Crane capacity / rental linking ---
constraint
  forall(t in TIME) (
    Loaded[t] <= CranesRented[t] * CraneCapacity
  );


% Objective
solve minimize
    sum(t in TIME)(UnloadCosts[t] * Unloaded[t])
  + sum(t in 1..T-1)(HoldingCost * InventoryEnd[t])
  + sum(t in TIME)(CraneCost * CranesRented[t]);