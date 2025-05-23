% Input data nomenclature
int: m; % Number of marks on the Golomb ruler

% Decision variables
array[1..m] of var 0..m*m: a; % Positions of the marks on the ruler

% Constraints
constraint a[1] = 0; % The first mark is at position 0
constraint increasing(a); % The marks are in increasing order
constraint forall(i in 1..m, j in i+1..m)(a[j] - a[i] != a[i+1] - a[i]); % All differences are distinct
constraint a[2] - a[1] < a[m] - a[m-1]; % Symmetry breaking constraint

% Objective
solve minimize a[m]; % Minimize the length of the ruler

% Output
output ["Length of the smallest Golomb ruler with ", show(m), " marks: ", show(a[m])];