int: NumObs;
array[1..NumObs] of float: X;
array[1..NumObs] of float: Y;

/* Decision variables */
var float: a;          % intercept
var float: b;          % slope
var float: d;          % maximum absolute deviation

/* Constraints */
constraint d >= 0;
constraint forall(i in 1..NumObs) (
    d >= Y[i] - (b*X[i] + a)   % upper side of |error|
);
constraint forall(i in 1..NumObs) (
    d >= -Y[i] + b*X[i] + a    % lower side of |error|
);

/* Objective */
solve minimize d;

/* Output */
output [
    "Intercept a = ", show(a), "\n",
    "Slope     b = ", show(b), "\n",
    "Max. deviation d = ", show(d), "\n"
];