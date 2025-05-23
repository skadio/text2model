% Parameters
int: m; % Number of marks on the Golomb ruler

% Variables
array[1..m] of var 0..m*m: a; % Positions of the marks on the ruler

% Auxiliary Variables
array[1..m, 1..m] of var 0..m*m: diff; % Differences between each pair of marks

% Constraints
constraint forall(i in 1..m, j in 1..m where i < j) (
    diff[i,j] = a[j] - a[i]
);

constraint forall(i in 1..m, j in 1..m where i < j) (
    forall(k in 1..m, l in 1..m where k < l /\ (i != k \/ j != l)) (
        diff[i,j] != diff[k,l]
    )
);

constraint a[1] = 0;
constraint increasing(a);
constraint a[2] - a[1] < a[m] - a[m-1];

% Objective
solve minimize a[m];