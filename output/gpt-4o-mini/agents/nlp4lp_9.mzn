include "globals.mzn";

int: K;                             % Number of terms in the sequence
array[0..K] of float: P;           % Coefficients of the linear combination
float: ExpectedZ;                  % Expected value of Z
float: ExpectedZSquared;           % Expected value of Z squared

/* Variables */
array[0..K] of var 0..1: p_k;      % Decision variables for probabilities
var float: E_Z4;                   % Variable for the fourth moment

/* Constraints */
constraint sum(i in 0..K)(p_k[i]) = 1;  % Probabilities must sum to 1

constraint sum(i in 0..K)(i * p_k[i]) = ExpectedZ;  % E[Z] constraint
constraint sum(i in 0..K)(i * i * p_k[i]) = ExpectedZSquared;  % E[Z^2] constraint

/* Objective: Maximize E[Z^4] */
E_Z4 = sum(i in 0..K)(i * i * i * i * p_k[i]);
solve maximize E_Z4;

/* Output */
output [ "Upper bound on E[Z^4] = ", show(E_Z4), "\n" ];