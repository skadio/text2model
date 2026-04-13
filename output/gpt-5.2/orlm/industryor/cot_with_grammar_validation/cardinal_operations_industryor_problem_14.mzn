int: n = 10;
array[1..n] of int: r = [3, 5, 2, 4, 6, 5, 4, 3, 2, 1];
int: a = 10;
int: b = 1;
int: c = 3;
int: p = 3;
int: q = 1;

int: Rmax = max(r);
int: U = sum(r);

array[1..n] of var 0..Rmax: use;
array[1..n] of var 0..U: buy;
array[1..n] of var 0..U: slow_send;
array[1..n] of var 0..U: fast_send;

array[0..n] of var 0..U: inv;

constraint inv[0] = 0;

constraint forall(j in 1..n) (
  use[j] = r[j]
);

constraint forall(j in 1..n) (
  inv[j] = inv[j-1]
           + buy[j]
           + (if j - p >= 1 then slow_send[j-p] else 0 endif)
           + (if j - q >= 1 then fast_send[j-q] else 0 endif)
           - use[j]
);

constraint forall(j in 1..n) (
  inv[j-1]
  + buy[j]
  + (if j - p >= 1 then slow_send[j-p] else 0 endif)
  + (if j - q >= 1 then fast_send[j-q] else 0 endif)
  >= use[j]
);

constraint forall(j in 1..n) (
  slow_send[j] + fast_send[j] = use[j]
);

var int: total_cost =
  a * sum(j in 1..n)(buy[j])
  + b * sum(j in 1..n)(slow_send[j])
  + c * sum(j in 1..n)(fast_send[j]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "buy=", show(buy), "\n",
  "slow_send=", show(slow_send), "\n",
  "fast_send=", show(fast_send), "\n",
  "inv=", show(inv), "\n"
];