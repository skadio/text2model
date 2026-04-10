int: N;  % Number of types of products
array[1..N] of float: Demand;  % Demand of each product
float: MaxRegularAmount;  % Maximum production amount under regular conditions
float: CostRegular;  % Cost of production under regular conditions per unit
float: CostOvertime;  % Cost of production under overtime conditions per unit
float: StoreCost;  % Cost to store one unit of product

% Variables
array[1..N] of var 0..MaxRegularAmount: regular_production;  % Regular production amounts
array[1..N] of var 0..100: overtime_production;  % Overtime production amounts
array[1..N] of var 0..100: inventory;  % Inventory at the end of each month

% Constraints
constraint forall(n in 1..N) (
    regular_production[n] + overtime_production[n] + (if n > 1 then inventory[n-1] else 0 endif) >= Demand[n]
);

% Objective function: Minimize total cost
var float: total_cost = sum(n in 1..N)(CostRegular * regular_production[n] + CostOvertime * overtime_production[n] + StoreCost * inventory[n]);

% Solve
solve minimize total_cost;

% Output
output [ "Regular Production = ", show(regular_production), "\n",
         "Overtime Production = ", show(overtime_production), "\n",
         "Inventory = ", show(inventory), "\n",
         "Total Cost = ", show(total_cost), "\n" ];