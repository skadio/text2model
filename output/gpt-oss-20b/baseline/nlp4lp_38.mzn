int: N;
int: Capacity;
int: HoldingCost;
array[1..N] of int: Price;
array[1..N] of int: Cost;

array[1..N] of var 0..Capacity: buy;
array[1..N] of var 0..Capacity: sell;
array[1..N] of var 0..Capacity: stock;

constraint stock[1] = buy[1] - sell[1];
constraint forall(i in 2..N) (
    stock[i] = stock[i-1] + buy[i] - sell[i]
);
constraint stock[N] = 0;

var int: profit = sum(i in 1..N) (
    Price[i] * sell[i] - Cost[i] * buy[i] - HoldingCost * stock[i]
);

solve maximize profit;

output [
    "Profit: ", show(profit), "\n",
    "Buy: ", show(buy), "\n",
    "Sell: ", show(sell), "\n",
    "Stock: ", show(stock), "\n"
];