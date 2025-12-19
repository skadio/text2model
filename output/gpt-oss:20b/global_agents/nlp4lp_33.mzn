int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

var float: a in -1e6..1e6;
var float: b in -1e6..1e6;
var float: c in -1e6..1e6;

array[1..K] of var float: dev;

constraint
  forall(k in 1..K) (
    let {
      float pred = c * ObservedXValues[k] * ObservedXValues[k]
                 + b * ObservedXValues[k]
                 + a;
      float diff = ObservedValues[k] - pred;
    } in
    dev[k] >= diff /\ dev[k] >= -diff
  )
  /\ forall(k in 1..K)( dev[k] <= 1e6 );   % optional upper bound for stability

solve minimize sum(dev);

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "c = ", show(c), "\n",
  "sum of absolute deviations = ", show(sum(dev)), "\n"
];