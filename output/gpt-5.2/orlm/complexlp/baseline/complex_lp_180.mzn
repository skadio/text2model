% Air traffic landing times - maximize minimum separation
int: n = 10;

array[1..n] of int: a = [0,10,20,30,40,50,60,70,80,90];
array[1..n] of int: b = [60,70,80,90,100,110,120,130,140,150];

int: minA = min(a);
int: maxB = max(b);

array[1..n] of var minA..maxB: t;   % landing times
var 0..(maxB - minA): d;            % minimum separation to maximize

constraint forall(j in 1..n) (
  a[j] <= t[j] /\ t[j] <= b[j]
);

% Must land in order 1..n with separation at least d
constraint forall(j in 1..n-1) (
  t[j+1] - t[j] >= d
);

solve maximize d;

output [
  "max_min_separation = ", show(d), "\n",
  "landing_times = ", show(t), "\n"
];