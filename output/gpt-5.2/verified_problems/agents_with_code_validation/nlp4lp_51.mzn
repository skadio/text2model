include "globals.mzn";

%----------------------------
% Parameters
%----------------------------
int: W;                                  % Number of weeks
set of int: Weeks = 1..W;

int: RegularCost;                        % Cost per regular labor hour
int: OvertimeCost;                       % Cost per overtime labor hour
float: AssemblyTime;                     % Hours per basket

int: MaterialCost;                       % Material cost per basket
int: SellingPrice;                       % Selling price per basket
int: HoldingCost;                        % Holding cost per basket per week (weeks 1..W-1)
int: SalvageValue;                       % Salvage value per basket at end of season

array[Weeks] of int: Demand;             % Demand per week
array[Weeks] of int: RegularLabor;       % Regular labor capacity (hours) per week
array[Weeks] of int: OvertimeLabor;      % Overtime labor capacity (hours) per week

% Scale time to avoid floats (improves performance and avoids timeout)
int: TIME_SCALE = 10;                    % one decimal place is enough for AssemblyTime=0.4
int: AssemblyTimeI = round(AssemblyTime * int2float(TIME_SCALE));

% Upper bound on total baskets (over-production never helps due to costs)
int: TotalDemand = sum(w in Weeks)(Demand[w]);

%----------------------------
% Variables
%----------------------------
array[Weeks] of var 0..max(RegularLabor): regHoursUsed;
array[Weeks] of var 0..max(OvertimeLabor): otHoursUsed;

array[Weeks] of var 0..TotalDemand: produced;
array[Weeks] of var 0..TotalDemand: sold;

array[0..W] of var 0..TotalDemand: inventory;
var 0..TotalDemand: endInventory;

%----------------------------
% Constraints
%----------------------------
constraint inventory[0] = 0;

constraint forall(w in Weeks)(
  regHoursUsed[w] <= RegularLabor[w] /\
  otHoursUsed[w]  <= OvertimeLabor[w]
);

% Production limited by total hours used (scaled)
constraint forall(w in Weeks)(
  AssemblyTimeI * produced[w] <= TIME_SCALE * (regHoursUsed[w] + otHoursUsed[w])
);

% Demand satisfaction (must meet demand each week)
constraint forall(w in Weeks)(
  sold[w] = Demand[w]
);

% Must have enough baskets to meet demand
constraint forall(w in Weeks)(
  inventory[w-1] + produced[w] >= sold[w]
);

% Inventory balance
constraint forall(w in Weeks)(
  inventory[w] = inventory[w-1] + produced[w] - sold[w]
);

constraint endInventory = inventory[W];

%----------------------------
% Objective: maximize profit
%----------------------------
solve maximize
    sum(w in Weeks)(SellingPrice * sold[w])
  + SalvageValue * endInventory
  - sum(w in Weeks)(MaterialCost * produced[w])
  - sum(w in Weeks)(RegularCost * regHoursUsed[w] + OvertimeCost * otHoursUsed[w])
  - sum(w in 1..W-1)(HoldingCost * inventory[w]);