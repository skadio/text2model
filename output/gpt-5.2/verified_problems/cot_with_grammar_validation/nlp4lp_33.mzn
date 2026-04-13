int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

var -1.0e6..1.0e6: a;
var -1.0e6..1.0e6: b;
var -1.0e6..1.0e6: c;

array[1..K] of var -1.0e12..1.0e12: PredictedY;
array[1..K] of var 0.0..1.0e12: AbsDev;

var 0.0..1.0e12: TotalAbsDev;

constraint
  forall(k in 1..K) (
    PredictedY[k] = c * ObservedXValues[k] * ObservedXValues[k]
                  + b * ObservedXValues[k]
                  + a
  );

constraint
  forall(k in 1..K) (
    AbsDev[k] >= ObservedValues[k] - PredictedY[k] /\
    AbsDev[k] >= PredictedY[k] - ObservedValues[k]
  );

constraint
  TotalAbsDev = sum(k in 1..K)(AbsDev[k]);

solve minimize TotalAbsDev;