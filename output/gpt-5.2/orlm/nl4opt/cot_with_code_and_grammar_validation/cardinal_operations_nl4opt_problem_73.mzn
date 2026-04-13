% Parameters
int: budget = 100000;
int: telecom_max = 70000;
int: telecom_min_ratio = 3; % telecom >= 3 * healthcare

int: telecom_return_bp = 300;   % 3% = 300 basis points
int: healthcare_return_bp = 100; % 1% = 100 basis points

% Variables
var 0..budget: telecom;
var 0..budget: healthcare;
var 0..(budget * telecom_return_bp + budget * healthcare_return_bp): profit_bp;

% Constraints
constraint telecom + healthcare <= budget;
constraint telecom >= telecom_min_ratio * healthcare;
constraint telecom <= telecom_max;

constraint profit_bp = telecom_return_bp * telecom + healthcare_return_bp * healthcare;

% Objective
solve maximize profit_bp;