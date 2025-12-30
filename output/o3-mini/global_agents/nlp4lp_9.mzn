include "globals.mzn";

/* Data */
int: K;
array[1..K] of float: P;         % Provided but not used in the LP formulation
float: ExpectedZ;
float: ExpectedZSquared;

/* Decision variables:
   We consider a probability distribution p[1..K] over the K states,
   where the state corresponding to index i is (i-1). */
array[1..K] of var 0.0..1.0: p;

/* Auxiliary expressions for the moments */
% First moment (expected value)
var float: E_Z = sum(i in 1..K)( (i-1) * p[i] );

% Second moment
var float: E_Z2 = sum(i in 1..K)( (i-1)*(i-1) * p[i] );

% Fourth moment (our objective)
var float: E_Z4 = sum(i in 1..K)( pow(i-1,4) * p[i] );

/* Constraints */
constraint sum(i in 1..K)( p[i] ) = 1.0;
constraint E_Z = ExpectedZ;
constraint E_Z2 = ExpectedZSquared;

/* Solve: maximize the fourth moment */
solve maximize E_Z4;

/* Output results */
output [
  "Upper Bound on the Fourth Moment = ", show(E_Z4), "\n",
  "Probability distribution p = ", show(p), "\n"
];