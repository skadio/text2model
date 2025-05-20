% Parameters
int: n; % Number of bottle types
array[1..n] of int: b; % Number of bottles of each type
array[1..n] of int: t; % Number of bottles with each type of fill amount
int: num_people; % Number of people

% Variables
% Allocation of bottles to people. Each element represents the number of bottles of a certain type allocated to a person.
array[1..num_people, 1..n] of var 0..max(b): allocation;

% Constraints

% Each person should get the same number of bottles
constraint forall(i in 1..num_people-1) (
  sum(j in 1..n) (allocation[i,j]) = sum(j in 1..n) (allocation[i+1,j])
);

% The total number of bottles of each type should not exceed the available number of bottles of that type
constraint forall(j in 1..n) (
  sum(i in 1..num_people) (allocation[i,j]) = b[j]
);

% Each person should get the same amount of liquid
constraint forall(i in 1..num_people-1) (
  sum(j in 1..n) (allocation[i,j]*t[j]) = sum(j in 1..n) (allocation[i+1,j]*t[j])
);

% The allocations should be in lexicographical order
constraint forall(i in 1..num_people-1) (
  lex_lesseq(allocation[i,1..n], allocation[i+1,1..n])
);

% Objective
% Since we are not maximizing or minimizing any quantity, but rather finding a feasible solution that satisfies all constraints, we use the 'satisfy' keyword.
solve satisfy;