% Parameters (with values embedded)
int: total_budget = 100000;

set of string: Depts = {"X","Y","Z"};

array[Depts] of int: min_budget = ["X":30000, "Y":20000, "Z":10000];
array[Depts] of int: cost_per_employee = ["X":5000, "Y":3000, "Z":2000];

int: step = 1000; % budgets must be multiples of 1000

% Variables
array[Depts] of var 0..total_budget: budget;
var 0..sum(d in Depts)(budget[d]): total_cost;

% Constraints
constraint forall(d in Depts)(budget[d] mod step = 0);
constraint forall(d in Depts)(budget[d] >= min_budget[d]);
constraint sum(d in Depts)(budget[d]) <= total_budget;

% Total cost equals sum of per-department costs (interpreting budget as cost spent)
constraint total_cost = sum(d in Depts)(budget[d]);

% Objective
solve minimize total_cost;