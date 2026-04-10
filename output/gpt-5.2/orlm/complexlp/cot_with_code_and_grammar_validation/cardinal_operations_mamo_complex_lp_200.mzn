int: T = 6;
set of int: Months = 1..T;

array[Months] of int: demand = [430, 430, 380, 450, 520, 440];

int: initInv = 10;

int: regCap = 420;
int: otCap = 80;

int: regCost = 40;
int: otCost = 45;
int: holdCost = 3;

int: maxInventory = initInv + T * (regCap + otCap);

array[Months] of var 0..regCap: regProd;
array[Months] of var 0..otCap: otProd;
array[Months] of var 0..maxInventory: inv;

constraint inv[1] = initInv + regProd[1] + otProd[1] - demand[1];
constraint forall(m in 2..T) (
  inv[m] = inv[m-1] + regProd[m] + otProd[m] - demand[m]
);

var int: totalCost = sum(m in Months) (
  regCost * regProd[m] + otCost * otProd[m] + holdCost * inv[m]
);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "regProd=", show(regProd), "\n",
  "otProd=", show(otProd), "\n",
  "inv=", show(inv), "\n"
];