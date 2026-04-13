% Production planning with regular + overtime and inventory
% Uses integer decision variables to avoid float linear limitations in Gecode.

% Parameters
int: N;                                   % Number of periods (months)
set of int: IDX = 1..N;

array[IDX] of float: Demand;              % Demand each period

float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

% Convert (float) inputs to scaled integers to keep exact arithmetic
int: SCALE = 100;  % cents / hundredths of a unit

array[IDX] of int: DemandI = [ round(Demand[i] * SCALE) | i in IDX ];
int: MaxRegularI   = round(MaxRegularAmount * SCALE);

int: CostRegularI  = round(CostRegular  * SCALE);
int: CostOvertimeI = round(CostOvertime * SCALE);
int: StoreCostI    = round(StoreCost    * SCALE);

% Variables (scaled integers)
array[IDX] of var 0..sum(DemandI): regularProd;
array[IDX] of var 0..sum(DemandI): overtimeProd;
array[IDX] of var 0..sum(DemandI): inventory;

% Regular production capacity
constraint forall(i in IDX) (
  regularProd[i] <= MaxRegularI
);

% Inventory balance
constraint forall(i in IDX) (
  regularProd[i] + overtimeProd[i] + (if i = 1 then 0 else inventory[i-1] endif)
  =
  DemandI[i] + inventory[i]
);

% Objective (in scaled currency units)
var int: totalCost =
  sum(i in IDX)(
    CostRegularI  * regularProd[i] +
    CostOvertimeI * overtimeProd[i] +
    StoreCostI    * inventory[i]
  );

solve minimize totalCost;