% Parameters
int: K;                                   % Maximum value of Z (Z in 0..K)
array[0..K] of float: P;                  % Given probability mass function p_k (not used in optimization)
float: ExpectedZ;                         % Given first moment E[Z]
float: ExpectedZSquared;                  % Given second moment E[Z^2]

% Variables
array[0..K] of var float: p;              % Decision variables: probabilities p_k
var float: expectedZ4;                    % Fourth moment E[Z^4] (objective)

% Constraints

% --- Probability distribution validity ---
constraint forall(k in 0..K) (p[k] >= 0.0);   % Non-negativity
constraint sum(k in 0..K)(p[k]) = 1.0;        % Total probability 1

% --- Moment matching constraints (given E[Z] and E[Z^2]) ---
constraint sum(k in 0..K)(int2float(k) * p[k]) = ExpectedZ;
constraint sum(k in 0..K)(int2float(k*k) * p[k]) = ExpectedZSquared;

% --- Definition of fourth moment expression ---
constraint expectedZ4 = sum(k in 0..K)(int2float(k*k*k*k) * p[k]);

% Objective
solve maximize expectedZ4;