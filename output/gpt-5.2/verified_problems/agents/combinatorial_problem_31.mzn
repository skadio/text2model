% Parameters
int: num_people;  % Number of people in the kidney exchange program
set of int: PEOPLE = 1..num_people;  % Index set of people

array[PEOPLE, PEOPLE] of bool: compatible;
% compatible[i,j] = true if person i can donate a kidney to person j

% Variables
array[PEOPLE, PEOPLE] of var 0..1: exchange;
% exchange[i,j] = 1 if i donates to j (i -> j), else 0

array[PEOPLE] of var 0..1: participates;
% participates[p] = 1 if person p is included in an exchange cycle, else 0

% Constraints

% --- Compatibility enforcement: only allow donations along compatible arcs ---
constraint
  forall(i in PEOPLE, j in PEOPLE) (
    exchange[i, j] <= bool2int(compatible[i, j])
  );

% --- No self-donation: a person cannot donate to themselves ---
constraint
  forall(p in PEOPLE) (
    exchange[p, p] = 0
  );

% --- Flow conservation / cycle condition:
% If a person participates, they must have exactly one outgoing and one incoming donation.
% If they do not participate, they must have none.
constraint
  forall(p in PEOPLE) (
    sum(j in PEOPLE)(exchange[p, j]) = participates[p]
  );

constraint
  forall(p in PEOPLE) (
    sum(i in PEOPLE)(exchange[i, p]) = participates[p]
  );

% --- Optional strengthening: participation must reflect any incident exchange arc ---
% (Redundant given the equalities above, but can help propagation.)
constraint
  forall(p in PEOPLE) (
    participates[p] >= max(
      sum(j in PEOPLE)(exchange[p, j]),
      sum(i in PEOPLE)(exchange[i, p])
    )
  );

% Objective
solve maximize sum(p in PEOPLE)(participates[p]);