int: K;
float: ExpectedZ;
float: ExpectedZSquared;

array[0..K] of var float: p;

var float: EZ4;

constraint forall(k in 0..K) (p[k] >= 0.0);
constraint sum(k in 0..K) (p[k]) = 1.0;

constraint sum(k in 0..K) (k * p[k]) = ExpectedZ;
constraint sum(k in 0..K) (k*k * p[k]) = ExpectedZSquared;

constraint EZ4 = sum(k in 0..K) (k*k*k*k * p[k]);

solve maximize EZ4;