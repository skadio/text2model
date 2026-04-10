int: years = 2;
set of int: Y = 1..years;

array[Y] of int: a = [10, 15];          % jets produced in each year
int: pilots_per_training_jet = 5;

% Decision: how many jets in each year are allocated to training
array[Y] of var 0..max(a): train_jets;
constraint forall(y in Y)(train_jets[y] <= a[y]);

% Trained pilots available by end of year 2 (trained in year 1 and/or year 2)
var int: total_trained_pilots = pilots_per_training_jet * sum(y in Y)(train_jets[y]);

solve maximize total_trained_pilots;

output [
  "train_jets_year1=", show(train_jets[1]), "\n",
  "train_jets_year2=", show(train_jets[2]), "\n",
  "total_trained_pilots_end_year2=", show(total_trained_pilots), "\n"
];