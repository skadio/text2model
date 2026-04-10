% Accounting staffing LP: minimize weekly wage bill

% Parameters (embedded data)
int: cost_senior = 3000;
int: cost_junior = 1000;

int: min_total = 100;
int: min_senior = 5;

int: max_budget = 150000;

% Decision variables (LP -> continuous nonnegative)
var float: S; % number of senior accountants
var float: J; % number of junior accountants

constraint S >= 0.0;
constraint J >= 0.0;

% Contract requirements
constraint S + J >= float(min_total);
constraint S >= float(min_senior);

% Experience requirement: seniors at least one third of juniors
constraint S >= (1.0/3.0) * J;

% Budget limit
constraint cost_senior * S + cost_junior * J <= float(max_budget);

% Objective: minimize wage bill
var float: wage_bill = cost_senior * S + cost_junior * J;

solve minimize wage_bill;

output [
  "Senior accountants (S) = ", show(S), "\n",
  "Junior accountants (J)  = ", show(J), "\n",
  "Total accountants       = ", show(S + J), "\n",
  "Weekly wage bill        = $", show(wage_bill), "\n"
];