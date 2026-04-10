int: K;

set of int: S = 0..K;

float: ExpectedZ;
float: ExpectedZSquared;

array[S] of var float: p;

constraint forall(k in S) (p[k] >= 0.0);
constraint sum(k in S)(p[k]) = 1.0;

constraint sum(k in S)(int2float(k) * p[k]) = ExpectedZ;
constraint sum(k in S)(int2float(k*k) * p[k]) = ExpectedZSquared;

var float: ExpectedZFourth = sum(k in S)(int2float(k*k*k*k) * p[k]);

solve maximize ExpectedZFourth;

output [
  "UpperBound_EZ4 = ", show(ExpectedZFourth), "\n",
  "p = [", concat([ if k==0 then "" else ", " endif ++ show(p[k]) | k in S ]), "]\n"
];