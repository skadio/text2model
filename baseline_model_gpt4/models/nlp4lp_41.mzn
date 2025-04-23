include "globals.mzn";

% Parameters
int: N; % Number of types of products
array[1..N] of float: Demand; % Demand of product n
float: MaxRegularAmount; % Maximum production amount under regular conditions
float: CostRegular; % Cost of production under regular conditions per unit
float: CostOvertime; % Cost of production under overtime conditions per unit
float: StoreCost; % Cost to store one unit of product

% Decision Variables
array[1..N] of var 0.0..MaxRegularAmount: RegularProduction; % Regular production for each product
array[1..N] of var 0.0..Demand[i]: OvertimeProduction; % Overtime production for each product
array[1..N] of var 0.0..Demand[i]: Storage; % Storage for each product

% Objective
var float: TotalCost = sum(i in 1..N) (RegularProduction[i]*CostRegular + OvertimeProduction[i]*CostOvertime + Storage[i]*StoreCost);

% Constraints
constraint forall(i in 1..N) (RegularProduction[i] + OvertimeProduction[i] + (if i > 1 then Storage[i-1] else 0) >= Demand[i]);
constraint forall(i in 1..N) (RegularProduction[i] + OvertimeProduction[i] + (if i > 1 then Storage[i-1] else 0) - Demand[i] = Storage[i]);

% Solve
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n",
        "Regular Production: ", show(RegularProduction), "\n",
        "Overtime Production: ", show(OvertimeProduction), "\n",
        "Storage: ", show(Storage), "\n"];