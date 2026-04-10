% Parameters
int: max_total_budget = 10000;              % Maximum total budget available ($)
int: min_patient_care = 2000;               % Minimum funding for patient care X ($)
int: min_medical_research = 1500;           % Minimum funding for medical research Y ($)
int: min_hospital_maintenance = 500;        % Minimum funding for hospital maintenance Z ($)

float: eff_patient_care = 0.5;              % Cost effectiveness per $ for X
float: eff_medical_research = 0.3;          % Cost effectiveness per $ for Y
float: eff_hospital_maintenance = 0.2;      % Cost effectiveness per $ for Z

% Variables
var min_patient_care..max_total_budget: X;                  % Allocation to patient care ($, integer)
var min_medical_research..max_total_budget: Y;              % Allocation to medical research ($, integer)
var min_hospital_maintenance..max_total_budget: Z;          % Allocation to hospital maintenance ($, integer)

var 0..max_total_budget: total_budget;                      % Total allocated budget ($)

% Total "cost" objective value (effectiveness-weighted spend)
var 0.0..(eff_patient_care + eff_medical_research + eff_hospital_maintenance)
        * int2float(max_total_budget): total_cost;

% Constraints
% --- Budget aggregation and limit ---
constraint total_budget = X + Y + Z;
constraint total_budget <= max_total_budget;

% --- Minimum funding requirements (redundant with variable domains, kept for clarity) ---
constraint X >= min_patient_care;
constraint Y >= min_medical_research;
constraint Z >= min_hospital_maintenance;

% --- Total cost computation (effectiveness-weighted spend) ---
constraint
  total_cost = eff_patient_care * int2float(X)
             + eff_medical_research * int2float(Y)
             + eff_hospital_maintenance * int2float(Z);

% Objective
solve minimize total_cost;