int: W;                          % Number of weeks
int: RegularCost;                % Cost of regular labor per unit of time
int: OvertimeCost;               % Cost of overtime labor per unit of time
float: AssemblyTime;             % Time required to assemble a single basket
int: MaterialCost;               % Cost of materials per basket
int: SellingPrice;               % Selling price per basket
int: HoldingCost;                % Holding cost per basket per unit of time
int: SalvageValue;               % Salvage value per unsold basket at the end of the season
array[1..W] of int: Demand;      % Demand for baskets in each week
array[1..W] of int: RegularLabor; % Regular labor units available in each week
array[1..W] of int: OvertimeLabor; % Overtime labor units available in each week

% Decision variables
array[1..W] of var 0..max(Demand): BasketsProduced; % Baskets produced each week
array[1..W] of var 0..max(Demand): BasketsHeld;     % Baskets held at the end of each week
array[1..W] of var 0..RegularLabor[i]: RegularHours; % Regular labor hours used each week
array[1..W] of var 0..OvertimeLabor[i]: OvertimeHours; % Overtime labor hours used each week

% Constraints
constraint forall(w in 1..W) (
    BasketsProduced[w] + BasketsHeld[w] = Demand[w] + (if w > 1 then BasketsHeld[w-1] else 0 endif) 
);

constraint forall(w in 1..W) (
    RegularHours[w] <= RegularLabor[w] * 1.0  % Regular hours cannot exceed available regular labor
);

constraint forall(w in 1..W) (
    OvertimeHours[w] <= OvertimeLabor[w] * 1.0  % Overtime hours cannot exceed available overtime labor
);

% Objective function: Maximize profit
var float: Profit = sum(w in 1..W) (
    (SellingPrice * BasketsProduced[w]) - 
    (RegularCost * RegularHours[w]) - 
    (OvertimeCost * OvertimeHours[w]) - 
    (MaterialCost * BasketsProduced[w]) - 
    (HoldingCost * BasketsHeld[w])
) + 
sum(w in 1..W) (SalvageValue * BasketsHeld[W]); % Add salvage value of unsold baskets at the end

solve maximize Profit;

output [
    "Profit = ", show(Profit), "\n",
    "Baskets Produced = ", show(BasketsProduced), "\n",
    "Baskets Held = ", show(BasketsHeld), "\n",
    "Regular Hours = ", show(RegularHours), "\n",
    "Overtime Hours = ", show(OvertimeHours), "\n"
];