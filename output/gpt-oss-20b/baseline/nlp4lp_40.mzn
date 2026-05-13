int: K;
int: S;

array[1..K, 1..S] of int: Time;
array[1..K] of int: Profit;
array[1..S] of int: Capacity;

array[1..K] of var 0..maxint: qty;
var int: totalProfit;

constraint
    forall(s in 1..S) (
        sum(k in 1..K) qty[k] * Time[k,s] <= Capacity[s]
    );

constraint
    totalProfit = sum(k in 1..K) qty[k] * Profit[k];

solve maximize totalProfit;

output [
    "Total profit: ", show(totalProfit), "\n",
    "Quantities: ", show(qty), "\n"
];