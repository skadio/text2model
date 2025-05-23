% Parameters
int: W;
array[1..W] of int: Demand;
array[1..W] of int: RegularLabor;
array[1..W] of int: OvertimeLabor;

float: RegularCost;
float: OvertimeCost;
float: AssemblyTime;
float: MaterialCost;
float: SellingPrice;
float: HoldingCost;
float: SalvageValue;

% Derived constant
int: TotalDemand = sum(w in 1..W)(Demand[w]);

% Decision variables
array[1..W] of var 0..TotalDemand: ProdReg;   % baskets produced with regular labour
array[1..W] of var 0..TotalDemand: ProdOT;    % baskets produced with overtime labour
array[0..W] of var 0..TotalDemand: Inv;       % inventory (Inv[0] = 0)

% Initial inventory
constraint Inv[0] = 0;

% Capacity constraints
constraint
  forall(w in 1..W)(
      AssemblyTime * int2float(ProdReg[w]) <= int2float(RegularLabor[w])
  );

constraint
  forall(w in 1..W)(
      AssemblyTime * int2float(ProdOT[w])  <= int2float(OvertimeLabor[w])
  );

% Inventory balance
constraint
  forall(w in 1..W)(
      Inv[w-1] + ProdReg[w] + ProdOT[w] - Demand[w] = Inv[w]
  );

% Objective: maximise profit
var float: Profit =
    SellingPrice * int2float(TotalDemand)
  - MaterialCost * sum(w in 1..W)(int2float(ProdReg[w] + ProdOT[w]))
  - RegularCost  * AssemblyTime * sum(w in 1..W)(int2float(ProdReg[w]))
  - OvertimeCost * AssemblyTime * sum(w in 1..W)(int2float(ProdOT[w]))
  - HoldingCost  * (if W > 1 then sum(w in 1..W-1)(int2float(Inv[w])) else 0.0 endif)
  + SalvageValue * int2float(Inv[W]);

solve maximize Profit;