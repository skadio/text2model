int: T = 5;
set of int: TYPES = 1..T;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[TYPES] of int: qty = [120, 90, 300, 90, 120];

int: SCALE = 100;
array[TYPES] of int: w = [50, 100, 40, 60, 65];

int: cap = 60 * SCALE;
int: minload = 18 * SCALE;

int: minD = 12;

int: Nmax = sum(t in TYPES)(qty[t]);
set of int: CONT = 1..Nmax;

array[CONT, TYPES] of var 0..max(qty): x;
array[CONT] of var 0..1: used;
array[CONT] of var 0..1: usedA;

constraint forall(t in TYPES)(
  sum(c in CONT)(x[c, t]) = qty[t]
);

constraint forall(c in CONT)(
  sum(t in TYPES)(w[t] * x[c, t]) <= cap * used[c]
);

constraint forall(c in CONT)(
  sum(t in TYPES)(w[t] * x[c, t]) >= minload * used[c]
);

constraint forall(c in CONT)(
  x[c, A] <= qty[A] * usedA[c]
);

constraint forall(c in CONT)(
  x[c, A] >= usedA[c]
);

constraint forall(c in CONT)(
  x[c, C] >= usedA[c]
);

constraint forall(c in CONT)(
  x[c, D] >= minD * used[c]
);

int: BIGX = max(qty);
constraint forall(c in CONT)(
  sum(t in TYPES)(x[c, t]) <= BIGX * used[c]
);

constraint forall(c in 1..Nmax - 1)(
  used[c] >= used[c + 1]
);

solve minimize sum(c in CONT)(used[c]);

output [
  "containers=", show(sum(c in CONT)(used[c])), "\n"
];