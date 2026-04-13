% Parameters
int: T;                                   % Number of time periods (months)
set of int: TIME = 1..T;                  % Index set for time

array[TIME] of int: Demands;              % Demand (containers needed by ships) in month t
array[TIME] of int: UnloadCosts;          % Cost to unload one container in month t
array[TIME] of int: UnloadCapacity;       % Max containers that can be unloaded in month t

int: HoldingCost;                         % Holding cost per container carried to next month
int: MaxContainer;                        % Max containers allowed in yard at end of any month
int: InitContainer;                       % Containers in yard at start of month 1

int: NumCranes;                           % Maximum cranes that can be rented each month
int: CraneCapacity;                       % Containers that one crane can load in a month
int: CraneCost;                           % Cost to rent one crane (per month)


% Variables
array[TIME] of var 0..max(UnloadCapacity): unload;           % Containers unloaded from rail in month t
array[TIME] of var 0..MaxContainer: inventory_end;           % Containers in yard at end of month t

array[TIME] of var 0..NumCranes: cranes_rented;              % Cranes rented in month t (integer)
array[TIME] of var 0..(NumCranes * CraneCapacity): loaded;   % Containers loaded onto ships in month t


% Constraints
% --- Unloading limits (cannot exceed monthly unloading capacity) ---
constraint
  forall(t in TIME) (
    unload[t] <= UnloadCapacity[t]
  );

% --- Crane loading capacity (loaded containers limited by rented cranes) ---
constraint
  forall(t in TIME) (
    loaded[t] <= cranes_rented[t] * CraneCapacity
  );

% --- Demand fulfillment (ships' demand must be met each month) ---
constraint
  forall(t in TIME) (
    loaded[t] >= Demands[t]
  );

% --- Inventory flow balance (inventory evolution across months) ---
% inventory_end[t] = inventory at start of month t + unload[t] - loaded[t]
constraint
  inventory_end[1] = InitContainer + unload[1] - loaded[1];

constraint
  forall(t in 2..T) (
    inventory_end[t] = inventory_end[t-1] + unload[t] - loaded[t]
  );

% --- Yard storage capacity at end of each month ---
constraint
  forall(t in TIME) (
    inventory_end[t] <= MaxContainer
  );

% --- Terminal condition: no containers left after the last month ---
constraint
  inventory_end[T] = 0;


% Objective
solve minimize
  sum(t in TIME) (
    unload[t] * UnloadCosts[t]           % unloading cost
    + inventory_end[t] * HoldingCost     % holding cost for end-of-month inventory
    + cranes_rented[t] * CraneCost       % crane rental cost
  );