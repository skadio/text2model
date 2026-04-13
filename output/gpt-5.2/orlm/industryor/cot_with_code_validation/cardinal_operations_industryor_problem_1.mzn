% Parameters
int: Y = 2;                       % number of years
set of int: YEARS = 1..Y;

array[YEARS] of int: a = [10, 15]; % annual production of jets
int: pilots_per_training_jet = 5;

% Variables
array[YEARS] of var 0..max(a): train_jets;   % jets allocated to training each year
var 0..(pilots_per_training_jet * sum(a)): total_trained_pilots;

% Constraints
constraint forall(y in YEARS)(
  train_jets[y] <= a[y]
);

constraint total_trained_pilots = pilots_per_training_jet * sum(y in YEARS)(train_jets[y]);

% Objective
solve maximize total_trained_pilots;