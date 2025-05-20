% Parameters
int: N;
array[1..N] of float: Demand;
float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

% Auxiliary constant for upper bounds
float: BigM = sum(i in 1..N)(Demand[i]);

% Variables
array[1..N] of var 0.0..MaxRegularAmount: RegularProd;
array[1..N] of var 0.0..BigM: OvertimeProd;
array[1..N] of var 0.0..BigM: Inventory;
var float: TotalCost;

% Constraints
constraint
    Inventory[1] = RegularProd[1] + OvertimeProd[1] - Demand[1];

constraint
    forall(i in 2..N)(
        Inventory[i] = Inventory[i-1] + RegularProd[i] + OvertimeProd[i] - Demand[i]
    );

constraint
    Inventory[N] = 0.0;

% Objective
constraint
    TotalCost = sum(i in 1..N)(
        RegularProd[i] * CostRegular +
        OvertimeProd[i] * CostOvertime +
        Inventory[i]  * StoreCost
    );

solve minimize TotalCost;