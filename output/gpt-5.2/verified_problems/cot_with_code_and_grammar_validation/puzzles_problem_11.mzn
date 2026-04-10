% Parameters
int: n;                          % number of bottle types
array[1..n] of int: b;           % number of bottles of each type
array[1..n] of int: t;           % liquid amount per bottle type (scaled to integers, e.g., [2,1,0])
int: num_people;                 % number of people

% Variables
int: Btotal = sum(i in 1..n)(b[i]);
int: Ttotal = sum(i in 1..n)(b[i] * t[i]);

int: bottles_per_person = Btotal div num_people;
int: liquid_per_person  = Ttotal div num_people;

array[1..num_people, 1..n] of var int: x;   % x[p,i] = number of bottles of type i given to person p

% Constraints
constraint num_people > 0;

% each x is a feasible count
constraint forall(p in 1..num_people, i in 1..n) (
  x[p,i] >= 0 /\ x[p,i] <= b[i]
);

% total bottles and total liquid must be divisible for equal split
constraint Btotal mod num_people = 0;
constraint Ttotal mod num_people = 0;

% use all bottles exactly
constraint forall(i in 1..n) (
  sum(p in 1..num_people)(x[p,i]) = b[i]
);

% each person gets same number of bottles
constraint forall(p in 1..num_people) (
  sum(i in 1..n)(x[p,i]) = bottles_per_person
);

% each person gets same amount of liquid (scaled units)
constraint forall(p in 1..num_people) (
  sum(i in 1..n)(x[p,i] * t[i]) = liquid_per_person
);

% Lexicographical order of allocations (person 1 <=lex person 2 <=lex ...),
% using a strict total order by encoding each allocation row as a number in base (max_b+1)
int: max_b = max(i in 1..n)(b[i]);
int: base = max_b + 1;

array[1..n] of int: pow_base = [ pow(base, n-i) | i in 1..n ];

array[1..num_people] of var int: code;
constraint forall(p in 1..num_people)(
  code[p] = sum(i in 1..n)(x[p,i] * pow_base[i])
);

constraint forall(p in 1..num_people-1)(
  code[p] <= code[p+1]
);

% Objective
solve satisfy;