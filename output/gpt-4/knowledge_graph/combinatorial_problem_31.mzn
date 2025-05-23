% Parameters
int: num_people; % Number of people in the kidney exchange program
array[1..num_people, 1..num_people] of bool: compatible; % Compatibility matrix

% Variables
array[1..num_people, 1..num_people] of var 0..1: exchange; % Exchange matrix

% Constraints
constraint forall(i in 1..num_people)(
  sum(j in 1..num_people)(exchange[i,j]) = sum(j in 1..num_people)(exchange[j,i])
); % Every person who donates a kidney also receives one

constraint forall(i in 1..num_people, j in 1..num_people)(
  exchange[i,j] <= compatible[i,j]
); % Only compatible exchanges are allowed

% Objective
var int: total_exchanges = sum(i in 1..num_people, j in 1..num_people)(exchange[i,j]);
solve maximize total_exchanges;

% Output
output ["Total exchanges: ", show(total_exchanges), "\n"];
output ["Exchange matrix:\n"];
output [ if fix(exchange[i,j]) = 1 then "Person " ++ show(i) ++ " donates to Person " ++ show(j) ++ "\n" else "" endif | i in 1..num_people, j in 1..num_people];