% Parameters
int: Y = 2;
set of int: YEARS = 1..Y;

array[YEARS] of int: a = [10, 15];        % annual production of jets
int: pilots_per_training_jet = 5;         % pilots trained per training jet per year

% Variables
array[YEARS] of var 0..max(a): t;         % training jets allocated in each year
array[YEARS] of var 0..max(a): c;         % combat jets available in each year
var 0..pilots_per_training_jet*sum(a): total_trained_pilots;

% Constraints
constraint forall(y in YEARS) (
  t[y] + c[y] = a[y]
);

% trained pilots by end of year 2 come from training in years 1 and 2
constraint total_trained_pilots = pilots_per_training_jet * sum(y in YEARS)(t[y]);

% Objective
solve maximize total_trained_pilots;