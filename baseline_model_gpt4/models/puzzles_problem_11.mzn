include "globals.mzn";

% Number of bottle types
int: n;

% Number of bottles of each type
array[1..n] of int: b;

% Number of bottles with each type of fill amount
array[1..n] of int: t;

% Number of people
int: num_people;

% Total number of bottles
int: total_bottles = sum(b);

% Total amount of liquid
int: total_liquid = sum([b[i]*t[i] | i in 1..n]);

% Each person should get the same number of bottles
constraint total_bottles mod num_people = 0;

% Each person should get the same amount of liquid
constraint total_liquid mod num_people = 0;

% The number of bottles each person gets
var int: bottles_per_person = total_bottles div num_people;

% The amount of liquid each person gets
var int: liquid_per_person = total_liquid div num_people;

% Allocation of bottles to people
array[1..num_people, 1..n] of var 0..max(b): allocation;

% Each type of bottle is fully allocated
constraint forall(i in 1..n) (
  sum(j in 1..num_people) (allocation[j, i]) = b[i]
);

% Each person gets the same number of bottles
constraint forall(i in 1..num_people) (
  sum(j in 1..n) (allocation[i, j]) = bottles_per_person
);

% Each person gets the same amount of liquid
constraint forall(i in 1..num_people) (
  sum(j in 1..n) (allocation[i, j]*t[j]) = liquid_per_person
);

% Allocations should be in lexicographical order
constraint forall(i in 1..num_people-1) (
  lex_less_int(allocation[i], allocation[i+1])
);

solve satisfy;