int: K;
array[1..K] of float: P;
float: ExpectedZ;
float: ExpectedZSquared;

set of int: ZVals = 0..K;

array[ZVals] of var 0.0..1.0: Prob;

constraint sum(k in ZVals)(Prob[k]) = 1.0;
constraint sum(k in ZVals)(int2float(k) * Prob[k]) = ExpectedZ;
constraint sum(k in ZVals)(int2float(k * k) * Prob[k]) = ExpectedZSquared;

var float: FourthMoment = sum(k in ZVals)(int2float(k * k * k * k) * Prob[k]);

solve maximize FourthMoment;