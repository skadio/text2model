% Parameters
int: senior_weekly_wage = 3000;          % weekly wage per senior accountant
int: junior_weekly_wage = 1000;          % weekly wage per junior accountant
int: min_total_accountants = 100;        % minimum total accountants required
int: min_senior_accountants = 5;         % minimum senior accountants required
int: max_weekly_wage_bill = 150000;      % maximum allowed weekly wage bill

% Variables
var 0..max_weekly_wage_bill div senior_weekly_wage: num_senior;  % number of senior accountants
var 0..max_weekly_wage_bill div junior_weekly_wage: num_junior;  % number of junior accountants
var 0..max_weekly_wage_bill: wage_bill;                          % total weekly wage bill

% Constraints
% Wage bill calculation (link wage_bill to decision variables)
constraint
  wage_bill = senior_weekly_wage * num_senior + junior_weekly_wage * num_junior;

% Minimum staffing requirements (total and seniors)
constraint
  num_senior + num_junior >= min_total_accountants;

constraint
  num_senior >= min_senior_accountants;

% Experience mix requirement: seniors at least one third of juniors
% (avoid fractions by cross-multiplying)
constraint
  3 * num_senior >= num_junior;

% Weekly wage bill upper bound
constraint
  wage_bill <= max_weekly_wage_bill;

% Objective
solve minimize wage_bill;