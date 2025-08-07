% --------------------------------------------------------------------
%   Upper bound on the fourth moment of a discrete random variable
% --------------------------------------------------------------------
%   Input data (provided in a .dzn file)
%     K               : integer   (maximum value of Z)
%     ExpectedZ       : float     (E[Z])
%     ExpectedZSquared: float     (E[Z^2])
%     P               : array[1..K] of float   (unused, present only for compatibility)
%
%   The variables p[0..K] represent the unknown probability mass
%   function of Z.  We enforce:
%        * p[i] ≥ 0
%        * Σ p[i]            = 1
%        * Σ i  * p[i]       = ExpectedZ
%        * Σ i^2 * p[i]      = ExpectedZSquared
%   The objective is to maximise Σ i^4 * p[i], i.e. the fourth moment.
% --------------------------------------------------------------------

include "globals.mzn";

int: K;
float: ExpectedZ;
float: ExpectedZSquared;
array[1..K] of float: P;          % not used in the model

% --- Decision variables --------------------------------------------------
array[0..K] of var 0.0..1.0: p;   % probabilities p_0 ... p_K

% --- Constraints ----------------------------------------------------------
constraint sum(p) = 1.0;

constraint
  sum([float(i) * p[i] | i in 0..K]) = ExpectedZ;

constraint
  sum([float(i * i) * p[i] | i in 0..K]) = ExpectedZSquared;

% --- Objective (fourth moment) -------------------------------------------
var float: fourthMoment;
constraint
  fourthMoment = sum([float(i ^ 4) * p[i] | i in 0..K]);

solve maximize fourthMoment;

% --- Output ---------------------------------------------------------------
output [
  "Upper bound on E[Z^4] = ", show(fourthMoment), "\n",
  "Optimal probabilities: ", show(p), "\n"
];