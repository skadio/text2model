% Parameters
int: Y = 2;
array[1..Y] of int: a = [10, 15]; % annual production of fighter jets
int: pilots_per_training_jet = 5;

% Variables
array[1..Y] of var 0..max(a): train_jets;         % jets allocated to training in each year
array[1..Y] of var 0..max(a): combat_jets;        % remaining jets for combat each year
array[1..Y] of var 0..(pilots_per_training_jet*max(a)): pilots_trained; % pilots trained each year
var 0..(pilots_per_training_jet*sum(a)): total_pilots_by_end_year2;

% Constraints
constraint
  forall(j in 1..Y) (
    train_jets[j] + combat_jets[j] = a[j]
  );

constraint
  forall(j in 1..Y) (
    pilots_trained[j] = pilots_per_training_jet * train_jets[j]
  );

constraint
  total_pilots_by_end_year2 = sum(j in 1..Y)(pilots_trained[j]);

% Objective
solve maximize total_pilots_by_end_year2;