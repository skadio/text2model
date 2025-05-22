% Parameters
int: W;

float: RegularCost;
float: OvertimeCost;

float: AssemblyTime;
float: MaterialCost;
float: SellingPrice;
float: HoldingCost;
float: SalvageValue;

array[1..W] of int: Demand;
array[1..W] of float: RegularLabor;
array[1..W] of float: OvertimeLabor;

set of int: Weeks = 1..W;

% Decision variables
array[Weeks] of var 0.0..: RegHours;
array[Weeks] of var 0.0..: OvertimeHours;
array[Weeks] of var 0.0..: Prod;
array[Weeks] of var 0.0..: Inv;

% Production relation
constraint forall(w in Weeks)(
  Prod[w] = (RegHours[w] + OvertimeHours[w]) / AssemblyTime
);

% Labor limits
constraint forall(w in Weeks)(
  RegHours[w] <= RegularLabor[w] /\
  OvertimeHours[w] <= OvertimeLabor[w]
);

% Inventory balance
constraint Inv[1] = Prod[1] - int2float(Demand[1]);

constraint forall(w in 2..W)(
  Inv[w] = Inv[w-1] + Prod[w] - int2float(Demand[w])
);

% Non-negativity of inventory
constraint forall(w in Weeks)(Inv[w] >= 0.0);

% Objective: maximise profit
solve maximize
      SellingPrice * sum(w in Weeks)(int2float(Demand[w]))
    + SalvageValue * Inv[W]
    - HoldingCost  * sum(w in 1..(W-1))(Inv[w])
    - MaterialCost * sum(w in Weeks)(Prod[w])
    - RegularCost  * sum(w in Weeks)(RegHours[w])
    - OvertimeCost * sum(w in Weeks)(OvertimeHours[w]);