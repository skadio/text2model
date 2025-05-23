% Parameters
int: n; % Number of bottle types
array[1..n] of int: b; % Number of bottles of each type
array[1..n] of int: t; % Number of bottles with each type of fill amount
int: num_people; % Number of people

% Variables
array[1..n, 1..num_people] of var 0..max(b): allocation; % Allocation of bottles to each person

% Constraints
% Each person gets the same number of bottles
constraint forall(i in 1..n)(sum(j in 1..num_people)(allocation[i,j]) = b[i]);

% Each person gets the same amount of liquid
constraint forall(i in 1..num_people)(sum(j in 1..n)(allocation[j,i]*t[j]) = sum(k in 1..n)(b[k]*t[k])/num_people);

% Allocation should be in lexicographical order
constraint forall(i in 1..n-1, j in 1..num_people)(allocation[i,j] <= allocation[i+1,j]);

% Objective
solve satisfy;