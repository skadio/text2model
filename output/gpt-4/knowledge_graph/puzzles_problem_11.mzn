include "globals.mzn";

% Parameters
int: n; % Number of bottle types
array[1..n] of int: b; % Number of bottles of each type
array[1..n] of int: t; % Number of bottles with each type of fill amount
int: num_people; % Number of people

% Variables
array[1..n, 1..num_people] of var 0..max(b): allocation;

% Constraints
constraint forall(i in 1..n)(sum(j in 1..num_people)(allocation[i,j]) = b[i]);
constraint forall(j in 1..num_people)(sum(i in 1..n)(allocation[i,j]*t[i]) = sum(i in 1..n)(b[i]*t[i])/num_people);
constraint forall(j in 1..num_people)(sum(i in 1..n)(allocation[i,j]) = sum(i in 1..n)(b[i])/num_people);

% Lexicographical order
constraint forall(j in 1..num_people-1)(allocation[1,j] <= allocation[1,j+1]);
constraint forall(i in 1..n-1, j in 1..num_people)(allocation[i,j] <= allocation[i+1,j]);

% Objective
solve satisfy;