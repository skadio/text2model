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

% Each person should get the same amount of liquid
constraint forall(i in 1..num_people-1) (
  sum(j in 1..n) (allocation[i,j]*t[j]) = sum(j in 1..n) (allocation[i+1,j]*t[j])
);

% The total number of bottles of each type allocated should not exceed the number of bottles available
constraint forall(j in 1..n) (
  sum(i in 1..num_people) (allocation[i,j]) <= b[j]
);

% The allocations should be in lexicographical order
constraint forall(i in 1..num_people-1) (
  forall(j in 1..n) (
    if j < n then
      allocation[i,j] <= allocation[i,j+1]
    else
      allocation[i,j] <= allocation[i+1,1]
    endif
  )
);

% Objective
% Since the problem is about finding a feasible solution that satisfies all constraints, it is a satisfaction problem.
solve satisfy;