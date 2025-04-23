% Parameters
int: W; % Number of weeks in planning period
int: RegularCost; % Cost of regular labor per unit of time
int: OvertimeCost; % Cost of overtime labor per unit of time
int: AssemblyTime; % Time required to assemble a single basket
int: MaterialCost; % Cost of materials per basket
int: SellingPrice; % Selling price per basket
int: HoldingCost; % Holding cost per basket per unit of time
int: SalvageValue; % Salvage value per unsold basket at the end of the season
array[1..W] of int: Demand; % Demand for baskets in week w
array[1..W] of int: RegularLabor; % Number of regular labor units available in week w
array[1..W] of int: OvertimeLabor; % Number of overtime labor units available in week w

% Variables
array[1..W] of var 0..max(RegularLabor): RegularLaborUsed; % Regular labor used in week w
array[1..W] of var 0..max(OvertimeLabor): OvertimeLaborUsed; % Overtime labor used in week w
array[1..W] of var 0..max(Demand): BasketsProduced; % Baskets produced in week w
array[1..W] of var 0..max(Demand): BasketsSold; % Baskets sold in week w
array[1..W] of var 0..max(Demand): BasketsHeld; % Baskets held in week w
var 0..max(Demand): BasketsSalvaged; % Baskets salvaged at the end of the season

% Constraints

% The number of baskets produced in a week should not exceed the total labor available
constraint forall(w in 1..W) (
    BasketsProduced[w] <= (RegularLaborUsed[w] + OvertimeLaborUsed[w]) / AssemblyTime
);

% The number of baskets sold in a week should not exceed the demand
constraint forall(w in 1..W) (
    BasketsSold[w] <= Demand[w]
);

% The number of baskets held in a week should be equal to the number of baskets produced minus the number of baskets sold
constraint forall(w in 1..W) (
    BasketsHeld[w] = BasketsProduced[w] - BasketsSold[w]
);

% The number of baskets salvaged at the end of the season should be equal to the number of baskets held in the last week
constraint BasketsSalvaged = BasketsHeld[W];

% The regular labor used in a week should not exceed the regular labor available
constraint forall(w in 1..W) (
    RegularLaborUsed[w] <= RegularLabor[w]
);

% The overtime labor used in a week should not exceed the overtime labor available
constraint forall(w in 1..W) (
    OvertimeLaborUsed[w] <= OvertimeLabor[w]
);

% Objective
solve maximize sum(w in 1..W) (
    SellingPrice * BasketsSold[w] - 
    RegularCost * RegularLaborUsed[w] - 
    OvertimeCost * OvertimeLaborUsed[w] - 
    MaterialCost * BasketsProduced[w] - 
    HoldingCost * BasketsHeld[w]
) + SalvageValue * BasketsSalvaged;