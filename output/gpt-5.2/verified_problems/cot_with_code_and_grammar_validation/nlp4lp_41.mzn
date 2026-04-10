int: N;
array[1..N] of float: Demand;

float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

array[1..N] of var int: RegularProd;
array[1..N] of var int: OvertimeProd;
array[0..N] of var int: Inventory;

var int: TotalCost;

constraint Inventory[0] = 0;

constraint forall(t in 1..N) (
  RegularProd[t] >= 0 /\
  OvertimeProd[t] >= 0 /\
  Inventory[t] >= 0
);

constraint forall(t in 1..N) (
  RegularProd[t] <= ceil(MaxRegularAmount)
);

constraint forall(t in 1..N) (
  Inventory[t] = Inventory[t-1] + RegularProd[t] + OvertimeProd[t] - ceil(Demand[t])
);

constraint TotalCost =
  sum(t in 1..N) (
    ceil(CostRegular * int2float(RegularProd[t]) +
         CostOvertime * int2float(OvertimeProd[t]) +
         StoreCost * int2float(Inventory[t]))
  );

solve minimize TotalCost;