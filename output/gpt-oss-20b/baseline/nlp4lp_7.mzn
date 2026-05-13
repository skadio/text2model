int: X0;
int: V0;
int: XT;
int: VT;
int: T;

array[0..T-1] var int: a;
array[0..T] var int: x;
array[0..T] var int: v;
var int: maxAbsA;

constraint x[0] = X0;
constraint v[0] = V0;

constraint forall(t in 0..T-1) (
    x[t+1] = x[t] + v[t] /\
    v[t+1] = v[t] + a[t]
);

constraint x[T] = XT;
constraint v[T] = VT;

constraint forall(t in 0..T-1) (
    maxAbsA >= abs(a[t])
);

solve minimize maxAbsA;

output [
    "maxAbsA: ", show(maxAbsA), "\n",
    "a: ", show(a), "\n",
    "x: ", show(x), "\n",
    "v: ", show(v), "\n"
];