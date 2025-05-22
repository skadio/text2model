% Parameters
int: N;
array[1..N] of float: Demand;
float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

% Auxiliary parameter
float: BigM = sum(i in 1..N)(Demand[i]);

% Decision variables
array[1..N] of var 0.0..MaxRegularAmount: RegularProduction;
array[1..N] of var 0.0..BigM: OvertimeProduction;
array[1..N] of var 0.0..BigM: InventoryEnd;
var float: TotalCost;

% Constraints
constraint
  forall(t in 1..N) (
    (if t == 1 then 0.0 else InventoryEnd[t-1] endif) +
    RegularProduction[t] + OvertimeProduction[t] =
    Demand[t] + InventoryEnd[t]
  );

constraint InventoryEnd[N] = 0.0;

constraint
  TotalCost =
    sum(t in 1..N)(
      RegularProduction[t] * CostRegular +
      OvertimeProduction[t] * CostOvertime +
      InventoryEnd[t]       * StoreCost
    );

% Objective
solve minimize TotalCost;