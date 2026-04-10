% Parameters
int: total_budget = 100000;          % Total amount available to invest ($)
int: telecom_max = 70000;            % Maximum allowed investment in telecom ($)
int: telecom_min_ratio = 3;          % Telecom investment must be at least this multiple of healthcare
float: telecom_return = 0.03;        % Telecom return rate
float: healthcare_return = 0.01;     % Healthcare return rate

% Variables
var 0..total_budget: invest_telecom;     % Amount invested in telecom ($)
var 0..total_budget: invest_healthcare;  % Amount invested in healthcare ($)
var float: profit;                       % Total profit ($)

% Constraints
% Budget constraint: total investment cannot exceed available budget
constraint invest_telecom + invest_healthcare <= total_budget;

% Telecom upper bound constraint: telecom investment must be at most telecom_max
constraint invest_telecom <= telecom_max;

% Ratio constraint: telecom investment must be at least telecom_min_ratio times healthcare
constraint invest_telecom >= telecom_min_ratio * invest_healthcare;

% Profit definition: compute total profit from both investments
constraint profit = telecom_return * int2float(invest_telecom)
                  + healthcare_return * int2float(invest_healthcare);

% Objective
solve maximize profit;