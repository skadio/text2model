% Fighter jet training over 2 years (data embedded)

int: years = 2;
set of int: Y = 1..years;

array[Y] of int: production = [10, 15];   % a1=10, a2=15
int: pilots_per_training_jet_per_year = 5;

% Decision: how many jets in each year are allocated exclusively for training
array[Y] of var 0..max(production): training_jets;

% A year cannot allocate more training jets than produced
constraint forall(y in Y)(training_jets[y] <= production[y]);

% Trained pilots produced in each year
array[Y] of var 0..(max(production) * pilots_per_training_jet_per_year): trained_pilots_year;
constraint forall(y in Y)(
  trained_pilots_year[y] = training_jets[y] * pilots_per_training_jet_per_year
);

% Total trained pilots available by end of year 2
var 0..(sum(y in Y)(production[y]) * pilots_per_training_jet_per_year): total_trained_pilots;
constraint total_trained_pilots = sum(y in Y)(trained_pilots_year[y]);

% With no other objective given, maximize training to answer "how many ... in total"
solve maximize total_trained_pilots;

output [
  "Training jets per year = ", show(training_jets), "\n",
  "Trained pilots per year = ", show(trained_pilots_year), "\n",
  "Total trained pilots by end of year 2 = ", show(total_trained_pilots), "\n"
];