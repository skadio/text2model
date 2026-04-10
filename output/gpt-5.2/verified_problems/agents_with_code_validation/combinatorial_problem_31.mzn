% Parameters
int: num_people;                      % number of people in the kidney exchange program
set of int: PEOPLE = 1..num_people;   % index set for people

% Data is provided as 0/1 (int) in the .dzn, so read it as int and convert to bool
array[PEOPLE, PEOPLE] of int: compatible_int;  % 1 if donor j compatible with recipient i, else 0
array[PEOPLE, PEOPLE] of bool: compatible =
  array2d(PEOPLE, PEOPLE, [ compatible_int[i,j] = 1 | i in PEOPLE, j in PEOPLE ]);

% Variables
array[PEOPLE, PEOPLE] of var 0..1: exchange;
% exchange[i,j] = 1 if donor j gives a kidney to recipient i, else 0

% Constraints

% Compatibility enforcement: exchanges can only occur along compatible donor->recipient pairs
constraint
  forall(i in PEOPLE, j in PEOPLE) (
    exchange[i,j] <= compatible_int[i,j]
  );

% No self-donation
constraint
  forall(p in PEOPLE) (
    exchange[p,p] = 0
  );

% Flow balance: each person receives iff they donate (in-degree = out-degree)
constraint
  forall(p in PEOPLE) (
    sum(j in PEOPLE)(exchange[p,j]) = sum(i in PEOPLE)(exchange[i,p])
  );

% At most one incoming kidney per person
constraint
  forall(p in PEOPLE) (
    sum(j in PEOPLE)(exchange[p,j]) <= 1
  );

% At most one outgoing kidney per person
constraint
  forall(p in PEOPLE) (
    sum(i in PEOPLE)(exchange[i,p]) <= 1
  );

% Objective: maximize number of exchanges
solve maximize sum(i in PEOPLE, j in PEOPLE)(exchange[i,j]);