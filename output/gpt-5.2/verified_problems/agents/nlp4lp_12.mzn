% Parameters
int: T;                                  % Total number of periods (months)
set of int: PERIODS = 1..T;              % Index set for periods

array[PERIODS] of int: Deliver;          % Demand (units to deliver) at end of each period
int: StorageCost;                        % Inventory holding cost per unit per period
int: SwitchCost;                         % Cost per unit change in production level between periods

% Variables
array[PERIODS] of var int: Produce;      % Units produced in each period
array[PERIODS] of var int: Inventory;    % Inventory at end of each period (units on hand after delivery)
array[2..T] of var int: ProdChangeAbs;   % |Produce[i] - Produce[i-1]| for i=2..T (used for switch cost)

% Constraints

% --- Inventory flow balance (start with zero inventory) ---
constraint
  Inventory[1] = Produce[1] - Deliver[1];

constraint
  forall(i in 2..T) (
    Inventory[i] = Inventory[i-1] + Produce[i] - Deliver[i]
  );

% --- Feasibility: no backlogging and nonnegative production/inventory ---
constraint
  forall(i in PERIODS) (
    Produce[i] >= 0
  );

constraint
  forall(i in PERIODS) (
    Inventory[i] >= 0
  );

% --- Absolute production change definition for switching cost ---
constraint
  forall(i in 2..T) (
    ProdChangeAbs[i] >= Produce[i] - Produce[i-1]
  );

constraint
  forall(i in 2..T) (
    ProdChangeAbs[i] >= Produce[i-1] - Produce[i]
  );

constraint
  forall(i in 2..T) (
    ProdChangeAbs[i] >= 0
  );

% --- End-of-year inventory has no value and no storage cost ---
% No extra constraint is needed: inventory can be positive at T without penalty in the objective.

% Objective
solve minimize
  StorageCost * sum(i in 1..T-1)(Inventory[i])
  + SwitchCost * sum(i in 2..T)(ProdChangeAbs[i]);