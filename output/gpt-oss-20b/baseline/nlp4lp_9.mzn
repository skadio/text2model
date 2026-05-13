int: K;
array[0..K-1] of float: P;          % Coefficients (not used in the LP)
float: ExpectedZ;
float: ExpectedZSquared;

var float: p[0..K-1];

constraint
    sum(i in 0..K-1)(p[i]) = 1.0 /\          % probabilities sum to 1
    sum(i in 0..K-1)(i * p[i]) = ExpectedZ /\ % first moment
    sum(i in 0..K-1)(i * i * p[i]) = ExpectedZSquared /\ % second moment
    forall(i in 0..K-1)(p[i] >= 0.0);          % non‑negative probabilities

var float: E4 = sum(i in 0..K-1)(i^4 * p[i]);

solve maximize E4;

output [
    "E4: " ++ show(E4) ++ "\n",
    "p:  " ++ show(p) ++ "\n"
];