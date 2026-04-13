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

array[Weeks] of var float >= 0: reg_hours_used;
array[Weeks] of var float >= 0: ot_hours_used;

array[Weeks] of var int >= 0: produce;
array[Weeks] of var int >= 0: inventory;

constraint forall(w in Weeks) (
  reg_hours_used[w] <= RegularLabor[w] /\
  ot_hours_used[w]  <= OvertimeLabor[w]
);

constraint forall(w in Weeks) (
  AssemblyTime * int2float(produce[w]) <= reg_hours_used[w] + ot_hours_used[w]
);

constraint inventory[1] = produce[1] - Demand[1];
constraint forall(w in 2..W) (
  inventory[w] = inventory[w-1] + produce[w] - Demand[w]
);

var float: profit =
  sum(w in Weeks)(
    SellingPrice * int2float(Demand[w])
    - MaterialCost * int2float(produce[w])
    - RegularCost * reg_hours_used[w]
    - OvertimeCost * ot_hours_used[w]
    - (if w < W then HoldingCost * int2float(inventory[w]) else 0.0 endif)
  )
  + SalvageValue * int2float(inventory[W]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "reg_hours_used=", show(reg_hours_used), "\n",
  "ot_hours_used=", show(ot_hours_used), "\n",
  "produce=", show(produce), "\n",
  "inventory=", show(inventory), "\n"
];