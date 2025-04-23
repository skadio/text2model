% Parameters
int: W; % Number of weeks in planning period
float: RegularCost; % Cost of regular labor per unit of time
float: OvertimeCost; % Cost of overtime labor per unit of time
float: AssemblyTime; % Time required to assemble a single basket
float: MaterialCost; % Cost of materials per basket
float: SellingPrice; % Selling price per basket
float: HoldingCost; % Holding cost per basket per unit of time
float: SalvageValue; % Salvage value per unsold basket at the end of the season
array[1..W] of float: Demand; % Demand for baskets in week w
array[1..W] of float: RegularLabor; % Number of regular labor units available in week w
array[1..W] of float: OvertimeLabor; % Number of overtime labor units available in week w

% Variables
array[1..W] of var 0.0..max(RegularLabor): regularLaborUsed; % Regular labor used in week w
array[1..W] of var 0.0..max(OvertimeLabor): overtimeLaborUsed; % Overtime labor used in week w
array[1..W] of var 0..sum(Demand): basketsProduced; % Baskets produced in week w
array[1..W] of var 0..sum(Demand): basketsSold; % Baskets sold in week w
array[1..W] of var 0..sum(Demand): basketsHeld; % Baskets held in week w

% Constraints

% The number of baskets produced in a week should not exceed the total labor available (regular and overtime) divided by the assembly time per basket
constraint forall(w in 1..W) (
    basketsProduced[w] <= (regularLaborUsed[w] + overtimeLaborUsed[w]) / AssemblyTime
);

% The number of baskets sold in a week should not exceed the demand for that week
constraint forall(w in 1..W) (
    basketsSold[w] <= Demand[w]
);

% The number of baskets held at the end of a week is equal to the number of baskets produced minus the number of baskets sold
constraint basketsHeld[1] = basketsProduced[1] - basketsSold[1];
constraint forall(w in 2..W) (
    basketsHeld[w] = basketsHeld[w-1] + basketsProduced[w] - basketsSold[w]
);

% The regular labor used in a week should not exceed the regular labor available for that week
constraint forall(w in 1..W) (
    regularLaborUsed[w] <= RegularLabor[w]
);

% The overtime labor used in a week should not exceed the overtime labor available for that week
constraint forall(w in 1..W) (
    overtimeLaborUsed[w] <= OvertimeLabor[w]
);

% Objective
solve maximize 
    sum(w in 1..W) (SellingPrice * basketsSold[w] - RegularCost * regularLaborUsed[w] - OvertimeCost * overtimeLaborUsed[w] - MaterialCost * basketsProduced[w] - HoldingCost * basketsHeld[w]) 
    + SalvageValue * basketsHeld[W];