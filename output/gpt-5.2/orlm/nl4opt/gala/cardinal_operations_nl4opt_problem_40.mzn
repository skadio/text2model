% Accounting team staffing (LP formulated as an integer linear program in MiniZinc)

% Data (embedded as required)
int: wage_senior = 3000;
int: wage_junior = 1000;
int: min_total = 100;
int: min_senior = 5;
int: max_wage_bill = 150000;

% Decision variables
var 0..1000000: S; % number of senior accountants
var 0..1000000: J; % number of junior accountants

% Objective: minimize weekly wage bill
var 0..intmax: cost = wage_senior * S + wage_junior * J;

% Constraints
constraint S + J >= min_total;
constraint S >= min_senior;

% "Senior at least a third of junior"  =>  S >= J/3  =>  3S >= J
constraint 3 * S >= J;

% Wage budget
constraint cost <= max_wage_bill;

solve minimize cost;

output [
  "Senior = ", show(S), "\n",
  "Junior = ", show(J), "\n",
  "Total  = ", show(S + J), "\n",
  "Cost   = ", show(cost), "\n"
];