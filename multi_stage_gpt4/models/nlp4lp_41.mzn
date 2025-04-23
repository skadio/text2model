% Parameters
int: N; % Number of types of products
array[1..N] of int: Demand; % Demand of product n
int: MaxRegularAmount; % Maximum production amount under regular conditions
int: CostRegular; % Cost of production under regular conditions per unit
int: CostOvertime; % Cost of production under overtime conditions per unit
int: StoreCost; % Cost to store one unit of product

% Variables
array[1..N] of var 0..MaxRegularAmount: RegularProduction; % Regular production amount for each product
array[1..N] of var 0..MaxRegularAmount: OvertimeProduction; % Overtime production amount for each product
array[1..N] of var 0..MaxRegularAmount: StoredUnits; % Stored units for each product

% Constraints

% The total production (regular and overtime) for each product must meet the demand
constraint forall(n in 1..N) (
    RegularProduction[n] + OvertimeProduction[n] + StoredUnits[n] = Demand[n]
);

% The regular production for each product cannot exceed the maximum regular production amount
constraint forall(n in 1..N) (
    RegularProduction[n] <= MaxRegularAmount
);

% The overtime production for each product cannot exceed the maximum regular production amount
constraint forall(n in 1..N) (
    OvertimeProduction[n] <= MaxRegularAmount
);

% The stored units for each product cannot exceed the maximum regular production amount
constraint forall(n in 1..N) (
    StoredUnits[n] <= MaxRegularAmount
);

% The cost of regular production, overtime production and storage for each product must be minimized
constraint forall(n in 1..N) (
    RegularProduction[n]*CostRegular + OvertimeProduction[n]*CostOvertime + StoredUnits[n]*StoreCost <= Demand[n]*CostRegular
);

% Objective
solve minimize sum(n in 1..N) (RegularProduction[n]*CostRegular + OvertimeProduction[n]*CostOvertime + StoredUnits[n]*StoreCost);