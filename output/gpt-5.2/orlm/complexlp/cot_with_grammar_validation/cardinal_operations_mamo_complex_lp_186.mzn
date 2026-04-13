int: n = 8;
int: S = 1;
int: T = 8;

set of int: N = 1..n;

int: m = 20;
set of int: A = 1..m;

array[A] of int: tail = [
  1, 2,
  1, 3,
  2, 4,
  2, 3,
  3, 5,
  3, 6,
  4, 6,
  6, 7,
  5, 8,
  7, 8
];

array[A] of int: head = [
  2, 1,
  3, 1,
  4, 2,
  3, 2,
  5, 3,
  6, 3,
  6, 4,
  7, 6,
  8, 5,
  8, 7
];

array[A] of int: w = [
  4, 5,
  5, 4,
  3, 3,
  2, 2,
  1, 1,
  7, 7,
  2, 2,
  3, 3,
  5, 5,
  1, 1
];

int: maxW = max(a in A)(w[a]);
int: UB = (n - 1) * maxW;

array[N] of var 0..UB: dist;
array[A] of var bool: use;

constraint dist[S] = 0;

constraint forall(a in A)(
  dist[head[a]] <= dist[tail[a]] + w[a]
);

constraint forall(i in N where i != S)(
  dist[i] > 0 -> exists(a in A where head[a] = i)(use[a])
);

constraint forall(i in N where i != S)(
  sum(a in A where head[a] = i)(bool2int(use[a])) <= 1
);

constraint forall(a in A)(
  use[a] -> dist[head[a]] = dist[tail[a]] + w[a]
);

constraint forall(a in A)(
  use[a] -> dist[tail[a]] < dist[head[a]]
);

constraint sum(a in A where head[a] = T)(bool2int(use[a])) = 1;

solve minimize dist[T];

output ["Shortest distance S->T = ", show(dist[T]), " m\n"];