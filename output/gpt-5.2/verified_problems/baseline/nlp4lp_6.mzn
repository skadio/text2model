int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

set of int: T = 0..TotalTime;

array[T] of var int: x;
array[T] of var int: v;
array[0..TotalTime-1] of var int: a;

constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

constraint forall(t in 0..TotalTime-1) (
  x[t+1] = x[t] + v[t] /\
  v[t+1] = v[t] + a[t]
);

var int: fuel = sum(t in 0..TotalTime-1)(abs(a[t]));

solve minimize fuel;

output [
  "fuel = ", show(fuel), "\n",
  "x = ", show(x), "\n",
  "v = ", show(v), "\n",
  "a = ", show(a), "\n"
];