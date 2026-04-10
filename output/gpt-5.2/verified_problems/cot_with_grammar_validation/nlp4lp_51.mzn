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

array[1..W] of var float: reg_hours_used;
array[1..W] of var float: ot_hours_used;

array[1..W] of var int: produce;
array[1..W] of var int: sell;
array[0..W] of var int: inv;

constraint inv[0] = 0;

constraint forall(w in 1..W) (
  reg_hours_used[w] >= 0.0 /\ reg_hours_used[w] <= RegularLabor[w]
);

constraint forall(w in 1..W) (
  ot_hours_used[w] >= 0.0 /\ ot_hours_used[w] <= OvertimeLabor[w]
);

constraint forall(w in 1..W) (
  produce[w] >= 0 /\ sell[w] >= 0 /\ inv[w] >= 0
);

constraint forall(w in 1..W) (
  sell[w] = Demand[w]
);

constraint forall(w in 1..W) (
  inv[w] = inv[w-1] + produce[w] - sell[w]
);

constraint forall(w in 1..W) (
  reg_hours_used[w] + ot_hours_used[w] = AssemblyTime * int2float(produce[w])
);

var float: profit =
    sum(w in 1..W) (SellingPrice * int2float(sell[w]))
  - sum(w in 1..W) (MaterialCost * int2float(produce[w]))
  - sum(w in 1..W) (RegularCost * reg_hours_used[w] + OvertimeCost * ot_hours_used[w])
  - sum(w in 1..W-1) (HoldingCost * int2float(inv[w]))
  + SalvageValue * int2float(inv[W]);

solve maximize profit;