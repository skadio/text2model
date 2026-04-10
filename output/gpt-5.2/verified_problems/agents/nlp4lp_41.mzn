% Parameters
int: N;                                  % Number of months (indexed 1..N)
set of int: Months = 1..N;               % Month index set

array[Months] of float: Demand;          % Demand in each month (must be met, no backlogging)

float: MaxRegularAmount;                 % Max regular production per month
float: CostRegular;                      % Regular production cost per unit
float: CostOvertime;                     % Overtime production cost per unit
float: StoreCost;                        % Inventory holding cost per unit per month

% Variables
array[Months] of var float: RegularProd; % Regular production in month t
array[Months] of var float: OvertimeProd;% Overtime production in month t
array[Months] of var float: Inventory;   % End-of-month inventory after meeting demand in month t

% Constraints
% --- Production capacity constraints (regular and overtime) ---
constraint
  forall(t in Months) (
    RegularProd[t] >= 0.0 /\
    RegularProd[t] <= MaxRegularAmount
  );

constraint
  forall(t in Months) (
    OvertimeProd[t] >= 0.0
  );

% --- Inventory feasibility constraints ---
constraint
  forall(t in Months) (
    Inventory[t] >= 0.0
  );

% --- Inventory balance constraints (demand must be met each month, no shortage) ---
constraint
  % Month 1 balance: assume initial inventory is 0
  RegularProd[1] + OvertimeProd[1] - Demand[1] = Inventory[1];

constraint
  % Month t balance for t >= 2
  forall(t in 2..N) (
    Inventory[t-1] + RegularProd[t] + OvertimeProd[t] - Demand[t] = Inventory[t]
  );

% Objective
solve minimize
  sum(t in Months)(
      CostRegular * RegularProd[t]
    + CostOvertime * OvertimeProd[t]
    + StoreCost * Inventory[t]
  );