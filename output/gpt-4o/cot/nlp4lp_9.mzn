% Parameters
int: K;
set of int: KRange = 0..K;

array[KRange] of float: P;            % Provided but not used in the optimisation
float: ExpectedZ;
float: ExpectedZSquared;

% Variables
array[KRange] of var 0.0..1.0: p;     % Probabilities p_k
var float: ExpectedZFourth;           % Fourth moment to be maximised

% Constraints
constraint sum(k in KRange)(p[k]) = 1;

constraint sum(k in KRange)(int2float(k) * p[k]) = ExpectedZ;

constraint sum(k in KRange)(int2float(k * k) * p[k]) = ExpectedZSquared;

constraint ExpectedZFourth = 
    sum(k in KRange)(int2float(k * k * k * k) * p[k]);

% Objective
solve maximize ExpectedZFourth;