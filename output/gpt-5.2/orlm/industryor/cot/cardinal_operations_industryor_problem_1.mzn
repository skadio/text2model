% Parameters (with values embedded)
int: J = 2;
set of int: YEARS = 1..J;
array[YEARS] of int: a = [10, 15];     % annual production of fighter jets
int: pilots_per_training_jet = 5;

% Variables
array[YEARS] of var 0..15: train_jets;  % jets allocated to training each year (bounded by max production 15)
array[YEARS] of var 0..75: trained_pilots; % trained pilots produced each year
var 0..150: total_trained_pilots;       % total by end of year 2

% Constraints
constraint forall(y in YEARS) (
  train_jets[y] <= a[y]
);

constraint forall(y in YEARS) (
  trained_pilots[y] = pilots_per_training_jet * train_jets[y]
);

constraint total_trained_pilots = sum(y in YEARS)(trained_pilots[y]);

% Objective
solve maximize total_trained_pilots;