% Input parameters
int: N; % Number of types of products
array[1..N] of float: Demand; % Demand of product n
float: MaxRegularAmount; % Maximum production amount under regular conditions
float: CostRegular; % Cost of production under regular conditions per unit
float: CostOvertime; % Cost of production under overtime conditions per unit
float: StoreCost; % Cost to store one unit of product

% Decision variables
array[1..N] of var 0.0..MaxRegularAmount: RegularProduction; % Regular production for each product
array[1..N] of var 0.0..Demand[i]: OvertimeProduction; % Overtime production for each product
array[1..N] of var 0.0..Demand[i]: Stored; % Stored units for each product

% Constraints
constraint forall(i in 1..N) (
    RegularProduction[i] + OvertimeProduction[i] + Stored[i] >= Demand[i]
);

% Objective function
var float: TotalCost = sum(i in 1..N) (
    CostRegular * RegularProduction[i] + 
    CostOvertime * OvertimeProduction[i] + 
    StoreCost * Stored[i]
);

% Solve
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++
["Regular production: ", show(RegularProduction), "\n"] ++
["Overtime production: ", show(OvertimeProduction), "\n"] ++
["Stored: ", show(Stored), "\n"];