int: X0;
int: V0;
int: XT;
int: VT;
int: T;

constraint T >= 1;

array[0..T] of var int: x;
array[0..T] of var int: v;
array[0..T-1] of var int: a;

var int: Amax;

constraint x[0] = X0;
constraint v[0] = V0;

constraint x[T] = XT;
constraint v[T] = VT;

constraint forall(t in 0..T-1) (
  x[t+1] = x[t] + v[t]
);

constraint forall(t in 0..T-1) (
  v[t+1] = v[t] + a[t]
);

constraint Amax >= 0;
constraint forall(t in 0..T-1) (
  a[t] <= Amax /\ -a[t] <= Amax
);

solve minimize Amax;