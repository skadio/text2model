int: T = 6;
set of int: Months = 1..T;

array[Months] of int: buyPrice  = [28, 24, 25, 27, 23, 23];
array[Months] of int: sellPrice = [29, 24, 26, 28, 22, 25];

int: capacity = 500;
int: initStock = 200;

array[Months] of var 0..capacity: buyQty;
array[Months] of var 0..capacity: sellQty;
array[0..T] of var 0..capacity: stock;

constraint stock[0] = initStock;

constraint forall(m in Months) (
  stock[m] = stock[m-1] + buyQty[m] - sellQty[m]
);

constraint forall(m in Months) (
  stock[m-1] + buyQty[m] <= capacity
);

constraint forall(m in Months) (
  sellQty[m] <= stock[m-1] + buyQty[m]
);

constraint forall(m in Months) (
  stock[m] <= capacity
);

var int: profit = sum(m in Months)(sellPrice[m]*sellQty[m] - buyPrice[m]*buyQty[m]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "buy=", show([buyQty[m] | m in Months]), "\n",
  "sell=", show([sellQty[m] | m in Months]), "\n",
  "stock=", show([stock[m] | m in 0..T]), "\n"
];