int: num_projects;
int: max_budget;
int: max_persons;
int: max_projects;

array[1..num_projects] of int: values;
array[1..num_projects] of int: budgets;
array[1..num_projects] of int: personell;

int: num_not_with;
array[1..num_not_with, 1..2] of int: not_with;

int: num_requires;
array[1..num_requires, 1..2] of int: requires;

array[1..num_projects] of var bool: x; % x[i]=true if project i is selected

constraint sum(i in 1..num_projects)(budgets[i] * bool2int(x[i])) <= max_budget;
constraint sum(i in 1..num_projects)(personell[i] * bool2int(x[i])) <= max_persons;
constraint sum(i in 1..num_projects)(bool2int(x[i])) <= max_projects;

% Projects that cannot be selected together
constraint
  forall(k in 1..num_not_with)(
    let { int: a = not_with[k,1], int: b = not_with[k,2] } in
      bool2int(x[a]) + bool2int(x[b]) <= 1
  );

% Projects that must be selected together (a requires b)
constraint
  forall(k in 1..num_requires)(
    let { int: a = requires[k,1], int: b = requires[k,2] } in
      bool2int(x[a]) <= bool2int(x[b])
  );

var int: total_value = sum(i in 1..num_projects)(values[i] * bool2int(x[i]));

solve maximize total_value;

output [
  "total_value=", show(total_value), "\n",
  "selected_projects=", show([i | i in 1..num_projects where fix(x[i])]), "\n",
  "total_budget=", show(sum(i in 1..num_projects)(budgets[i] * bool2int(x[i]))), "\n",
  "total_persons=", show(sum(i in 1..num_projects)(personell[i] * bool2int(x[i]))), "\n",
  "x=", show(x), "\n"
];