% Parameters
int: N;                                % Number of months (or product types)
array[1..N] of float: Demand;          % Demand in month i
float: MaxRegularAmount;               % Maximum units that can be produced regularly each month
float: CostRegular;                    % Regular–production cost per unit
float: CostOvertime;                   % Overtime-production cost per unit
float: StoreCost;                      % Inventory-holding cost per unit per month

float: TotalDemand =                   % A convenient upper-bound constant
  sum(i in 1..N)(Demand[i]);

% Variables
array[1..N] of var 0.0..MaxRegularAmount: RegularProd;     % Regular production in month i
array[1..N] of var 0.0..TotalDemand:      OvertimeProd;    % Overtime production in month i
array[0..N] of var 0.0..TotalDemand:      Inventory;       % Inventory at end of month i (Inventory[0] = initial)

% Constraints
constraint Inventory[0] = 0.0;           % No initial inventory

constraint
  forall(i in 1..N)(
    RegularProd[i] + OvertimeProd[i] + Inventory[i-1]
    = Demand[i] + Inventory[i]           % Flow-balance for each month
  );

constraint Inventory[N] = 0.0;           % No inventory carried past the planning horizon

% Objective
var float: TotalCost = sum(i in 1..N)(
    CostRegular  * RegularProd[i] +
    CostOvertime * OvertimeProd[i] +
    StoreCost    * Inventory[i]
);

solve minimize TotalCost;