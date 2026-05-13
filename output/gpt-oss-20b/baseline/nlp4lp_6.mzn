int: TotalTime;
float: InitialPosition;
float: InitialVelocity;
float: FinalPosition;
float: FinalVelocity;

array[0..TotalTime] of var float: x;
array[0..TotalTime] of var float: v;
array[0..TotalTime-1] of var float: a;

constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

constraint forall(t in 0..TotalTime-1) (
  x[t+1] = x[t] + v[t] /\ v[t+1] = v[t] + a[t]
);

constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

solve minimize sum(t in 0..TotalTime-1)(abs(a[t]));

output [
  "Accelerations: ", show(a), "\n",
  "Positions: ", show(x), "\n",
  "Velocities: ", show(v), "\n"
];