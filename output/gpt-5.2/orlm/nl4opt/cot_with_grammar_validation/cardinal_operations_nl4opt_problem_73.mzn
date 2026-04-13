% Parameters
int: total_budget = 100000;
int: telecom_max = 70000;
int: ratio = 3;                 % telecom >= ratio * healthcare
int: telecom_rate = 3;          % percent
int: healthcare_rate = 1;       % percent

% Variables
var 0..total_budget: telecom;
var 0..total_budget: healthcare;
var 0..(telecom_rate*total_budget + healthcare_rate*total_budget): profit_scaled;

% Constraints
constraint telecom + healthcare <= total_budget;
constraint telecom >= ratio * healthcare;
constraint telecom <= telecom_max;

constraint profit_scaled = telecom_rate * telecom + healthcare_rate * healthcare;

% Objective
solve maximize profit_scaled;