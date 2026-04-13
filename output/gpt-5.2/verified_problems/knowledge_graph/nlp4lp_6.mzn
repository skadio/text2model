int: TotalTime;

float: InitialPosition;
float: InitialVelocity;
float: FinalPosition;
float: FinalVelocity;

set of int: TIME = 0..TotalTime;
set of int: STEPS = 0..TotalTime-1;

array[TIME] of var float: x;
array[TIME] of var float: v;
array[STEPS] of var float: a;

constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

constraint forall(t in STEPS) (
  x[t+1] = x[t] + v[t]
);

constraint forall(t in STEPS) (
  v[t+1] = v[t] + a[t]
);

constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

var float: fuel = sum(t in STEPS)(abs(a[t]));

solve minimize fuel;

output [
  "fuel = ", show(fuel), "\n",
  "a = ", show(a), "\n",
  "x = ", show(x), "\n",
  "v = ", show(v), "\n"
];