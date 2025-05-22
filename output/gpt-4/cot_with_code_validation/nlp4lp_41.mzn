% Parameters
int: N; % Number of types of products
array[1..N] of float: Demand; % Demand of product n
float: MaxRegularAmount; % Maximum production amount under regular conditions
float: CostRegular; % Cost of production under regular conditions per unit
float: CostOvertime; % Cost of production under overtime conditions per unit
float: StoreCost; % Cost to store one unit of product

% Variables
array[1..N] of var 0.0..MaxRegularAmount: RegularProduction; % Regular production for each product
array[1..N] of var 0.0..float_plus_infinity: OvertimeProduction; % Overtime production for each product
array[1..N] of var 0.0..float_plus_infinity: Stored; % Stored units for each product

% Constraints
constraint forall(i in 1..N) (
    RegularProduction[i] + OvertimeProduction[i] + (if i > 1 then Stored[i-1] else 0 endif) = Demand[i] + Stored[i]
);
constraint forall(i in 1..N) (
    RegularProduction[i] <= MaxRegularAmount
);

% Objective
var float: TotalCost;
constraint TotalCost = sum(i in 1..N) (
    RegularProduction[i] * CostRegular + 
    OvertimeProduction[i] * CostOvertime + 
    (if i > 1 then Stored[i-1] else 0 endif) * StoreCost
);
solve minimize TotalCost;