% Parameters
int: num_people;
array[1..num_people, 1..num_people] of 0..1: compatible;

% Variables
array[1..num_people, 1..num_people] of var 0..1: donate;

% Constraints
% 1. No self-donation
constraint
  forall(i in 1..num_people) (
    donate[i,i] = 0
  );

% 2. Donation only allowed if compatible
constraint
  forall(i, j in 1..num_people) (
    donate[i,j] <= compatible[i,j]
  );

% 3. Each person donates at most once
constraint
  forall(i in 1..num_people) (
    sum(j in 1..num_people)( donate[i,j] ) <= 1
  );

% 4. Each person receives at most once
constraint
  forall(j in 1..num_people) (
    sum(i in 1..num_people)( donate[i,j] ) <= 1
  );

% 5. A participant must both donate and receive, or do neither
constraint
  forall(k in 1..num_people) (
    sum(j in 1..num_people)( donate[k,j] ) =
    sum(i in 1..num_people)( donate[i,k] )
  );

% Objective
solve maximize
  sum(i, j in 1..num_people)( donate[i,j] );