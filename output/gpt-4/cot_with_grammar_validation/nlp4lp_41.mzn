% Parameters
int: N; % Number of types of products
array[1..N] of float: Demand; % Demand of product n
float: MaxRegularAmount; % Maximum production amount under regular conditions
float: CostRegular; % Cost of production under regular conditions per unit
float: CostOvertime; % Cost of production under overtime conditions per unit
float: StoreCost; % Cost to store one unit of product

% Variables
array[1..N] of var 0.0..MaxRegularAmount: RegularProduction; % Regular production for each product
array[1..N] of var 0.0..MaxRegularAmount: OvertimeProduction; % Overtime production for each product
array[1..N] of var 0.0..MaxRegularAmount: Stored; % Stored units for each product

% Constraints
constraint forall(i in 1..N) (
    RegularProduction[i] + OvertimeProduction[i] + Stored[i] >= Demand[i] % Demand must be satisfied
);

constraint forall(i in 1..N) (
    RegularProduction[i] <= MaxRegularAmount % Regular production limit
);

% Objective
var float: TotalCost; % Total cost of production and storage
constraint TotalCost = sum(i in 1..N) (
    RegularProduction[i]*CostRegular + OvertimeProduction[i]*CostOvertime + Stored[i]*StoreCost
);
solve minimize TotalCost;