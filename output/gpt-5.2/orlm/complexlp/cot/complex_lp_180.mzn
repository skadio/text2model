% Parameters (with values embedded)
int: n = 10;
set of int: Flights = 1..n;

array[Flights] of int: a = [0,10,20,30,40,50,60,70,80,90];
array[Flights] of int: b = [60,70,80,90,100,110,120,130,140,150];

int: minTime = min(a);
int: maxTime = max(b);

% Variables
array[Flights] of var minTime..maxTime: t;   % landing times
var 0..(maxTime - minTime): sep;             % minimum separation (to maximize)

% Constraints
constraint forall(j in Flights) (
  a[j] <= t[j] /\ t[j] <= b[j]
);

% Flights must land in order 1..n with at least sep between consecutive landings
constraint forall(j in 1..n-1) (
  t[j+1] - t[j] >= sep
);

% Objective
solve maximize sep;

output [
  "Maximal minimum separation (rounded to nearest time): ", show(sep), "\n",
  "Landing times: ", show(t), "\n"
];