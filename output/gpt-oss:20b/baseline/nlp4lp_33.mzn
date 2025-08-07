int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

var float: a;
var float: b;
var float: c;

var float: total_abs_dev = sum(k in 1..K)(
    abs(c * ObservedXValues[k] * ObservedXValues[k] + b * ObservedXValues[k] + a - ObservedValues[k])
);

solve minimize total_abs_dev;

output [
    "a: ", show(a), "\n",
    "b: ", show(b), "\n",
    "c: ", show(c), "\n",
    "Total absolute deviation: ", show(total_abs_dev), "\n"
];