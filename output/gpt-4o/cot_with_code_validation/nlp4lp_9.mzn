% Parameters
int: K;                                    % Number of support points (values 0..K-1)
array[1..K] of float: P;                   % Provided probability vector (not used in optimisation)
float: ExpectedZ;                          % Given E[Z]
float: ExpectedZSquared;                   % Given E[Z^2]

% Variables
array[0..K-1] of var 0.0..1.0: p;          % Decision probabilities p_k  (k = 0..K-1)
var float: fourthMoment;                   % E[Z^4] to be maximised

% Constraints
constraint
    sum(k in 0..K-1)(p[k]) = 1.0;                          % Probabilities sum to 1
constraint
    sum(k in 0..K-1)(k * p[k]) = ExpectedZ;                % First moment
constraint
    sum(k in 0..K-1)(k * k * p[k]) = ExpectedZSquared;     % Second moment

% Objective
constraint
    fourthMoment = sum(k in 0..K-1)(k * k * k * k * p[k]); % Definition of E[Z^4]

solve maximize fourthMoment;