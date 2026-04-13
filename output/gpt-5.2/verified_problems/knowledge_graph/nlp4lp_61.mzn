int: T;
set of int: PERIODS = 1..T;

array[PERIODS] of int: Demands;
array[PERIODS] of int: UnloadCosts;
array[PERIODS] of int: UnloadCapacity;

int: HoldingCost;
int: MaxContainer;
int: InitContainer;

int: NumCranes;
int: CraneCapacity;
int: CraneCost;

array[PERIODS] of var 0..max(UnloadCapacity): ContainersUnloaded;
array[PERIODS] of var 0..MaxContainer: ContainersHeld;   % inventory at end of period t
array[PERIODS] of var 0..NumCranes: CranesRented;

% Unloading capacity (rail/terminal capacity)
constraint forall(t in PERIODS) (
  ContainersUnloaded[t] <= UnloadCapacity[t]
);

% Crane loading capacity to meet demand (ships)
constraint forall(t in PERIODS) (
  Demands[t] <= CranesRented[t] * CraneCapacity
);

% Inventory balance and storage capacity
constraint forall(t in PERIODS) (
  ContainersHeld[t] <= MaxContainer
);

constraint
  ContainersHeld[1] = InitContainer + ContainersUnloaded[1] - Demands[1];

constraint forall(t in 2..T) (
  ContainersHeld[t] = ContainersHeld[t-1] + ContainersUnloaded[t] - Demands[t]
);

% Final inventory must be zero
constraint ContainersHeld[T] = 0;

% Objective: unloading + holding + crane rental costs
var int: TotalCost =
  sum(t in PERIODS)(ContainersUnloaded[t] * UnloadCosts[t])
+ sum(t in PERIODS)(ContainersHeld[t] * HoldingCost)
+ sum(t in PERIODS)(CranesRented[t] * CraneCost);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "ContainersUnloaded = ", show(ContainersUnloaded), "\n",
  "ContainersHeld = ", show(ContainersHeld), "\n",
  "CranesRented = ", show(CranesRented), "\n"
];