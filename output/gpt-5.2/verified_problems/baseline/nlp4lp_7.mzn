int: T;

float: X0;
float: V0;
float: XT;
float: VT;

set of int: Time = 0..T;

array[Time] of var float: x;
array[Time] of var float: v;
array[0..T-1] of var float: a;

var float: Amax;

constraint x[0] = X0;
constraint v[0] = V0;

constraint x[T] = XT;
constraint v[T] = VT;

constraint forall(t in 0..T-1) (
  x[t+1] = x[t] + v[t] /\
  v[t+1] = v[t] + a[t]
);

constraint forall(t in 0..T-1) (
  Amax >= a[t] /\
  Amax >= -a[t]
);

constraint Amax >= 0.0;

solve minimize Amax;

output [
  "Amax = ", show(Amax), "\n",
  "a = ", show(a), "\n",
  "x = ", show(x), "\n",
  "v = ", show(v), "\n"
];