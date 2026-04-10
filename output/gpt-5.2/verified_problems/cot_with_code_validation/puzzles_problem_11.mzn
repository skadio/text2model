% Parameters
int: n;
array[1..n] of int: b;          % number of bottles of each type
array[1..n] of int: t;          % fill amount per bottle type, scaled to integers (e.g., [2,1,0])
int: num_people;

% Variables
array[1..n] of var 0..max(b): x;  % bottles of type i given to each person
var 0..sum(b): bottles_per_person;
var 0..(sum(i in 1..n)(t[i] * b[i])): liquid_per_person;

% Basic validity
constraint num_people > 0;

% Each person gets the same number of bottles
constraint bottles_per_person = sum(i in 1..n)(x[i]);
constraint num_people * bottles_per_person = sum(i in 1..n)(b[i]);

% Respect per-type availability (exactly all bottles are distributed)
constraint forall(i in 1..n)(
  num_people * x[i] = b[i]
);

% Each person gets the same amount of liquid (exactly all liquid is distributed)
constraint num_people * liquid_per_person = sum(i in 1..n)(t[i] * b[i]);

% Lexicographic order within a solution:
% force each person to receive the same per-type allocation vector x
% (this removes symmetric permutations of people)
% Nothing else is needed because x is per-person.

solve satisfy;

output [
  "x = ", show(x), "\n",
  "bottles_per_person = ", show(bottles_per_person), "\n",
  "liquid_per_person = ", show(liquid_per_person), "\n"
];