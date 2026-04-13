% Parameters
int: total_budget = 10000;              % Maximum total budget available ($)
int: min_patient_care = 2000;           % Minimum required funding for patient care ($)
int: min_medical_research = 1500;       % Minimum required funding for medical research ($)
int: min_maintenance = 500;             % Minimum required funding for hospital maintenance ($)

float: eff_patient_care = 0.5;          % Cost effectiveness per $ in patient care
float: eff_medical_research = 0.3;      % Cost effectiveness per $ in medical research
float: eff_maintenance = 0.2;           % Cost effectiveness per $ in maintenance

% Variables
var min_patient_care..total_budget: X;     % Allocation to patient care ($, integer)
var min_medical_research..total_budget: Y; % Allocation to medical research ($, integer)
var min_maintenance..total_budget: Z;      % Allocation to maintenance ($, integer)

var 0..total_budget: total_spend;          % Total allocated budget ($, integer)
var float: total_effectiveness;            % Total effectiveness (weighted sum, float)

% Constraints
% Budget accounting: define total spending as the sum of allocations
constraint
  total_spend = X + Y + Z;

% Total budget limit: spending cannot exceed the available budget
constraint
  total_spend <= total_budget;

% Minimum funding requirements (redundant with variable lower bounds, kept for clarity)
constraint
  X >= min_patient_care /\ Y >= min_medical_research /\ Z >= min_maintenance;

% Effectiveness accounting: compute weighted effectiveness from allocations
constraint
  total_effectiveness =
    eff_patient_care * int2float(X) +
    eff_medical_research * int2float(Y) +
    eff_maintenance * int2float(Z);

% Objective
solve minimize total_spend;