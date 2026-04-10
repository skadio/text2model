% Parameters
% Weekly wages (USD)
int: wage_senior = 3000;
int: wage_junior = 1000;

% Staffing requirements
int: min_total_accountants = 100;     % at least this many accountants total
int: min_senior_accountants = 5;      % at least this many seniors

% Experience mix requirement: seniors >= (1/3)*juniors
% Use integer ratio to avoid floats: 3*seniors >= juniors
int: ratio_num = 3;                  % multiplier on seniors
int: ratio_den = 1;                  % multiplier on juniors

% Wage bill cap (USD per week)
int: max_weekly_wage_bill = 150000;


% Variables
var 0..min_total_accountants: senior_accountants;   % number of senior accountants
var 0..min_total_accountants: junior_accountants;   % number of junior accountants
var 0..max_weekly_wage_bill: weekly_wage_bill;      % total wage bill (objective)


% Constraints

% --- Wage bill definition ---
% Define total weekly wage bill from staffing levels
constraint
  weekly_wage_bill = wage_senior * senior_accountants + wage_junior * junior_accountants;

% --- Minimum total staffing requirement ---
% At least the required number of accountants in total
constraint
  senior_accountants + junior_accountants >= min_total_accountants;

% --- Minimum senior staffing requirement ---
% At least the required number of senior accountants
constraint
  senior_accountants >= min_senior_accountants;

% --- Experience mix requirement ---
% Seniors must be at least one third of juniors: ratio_num * seniors >= ratio_den * juniors
constraint
  ratio_num * senior_accountants >= ratio_den * junior_accountants;

% --- Wage bill cap ---
% Weekly wage bill must not exceed the maximum allowed
constraint
  weekly_wage_bill <= max_weekly_wage_bill;


% Objective
solve minimize weekly_wage_bill;