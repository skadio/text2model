% Parameters
int: doctor_cost_per_hour = 10;      % Cost per doctor hour (units/hour)
int: nurse_cost_per_hour  = 20;      % Cost per nurse hour (units/hour)

int: min_care_effort  = 50;          % Minimum required care effort
int: max_overwork     = 150;         % Maximum allowed overwork measure
int: min_doctor_extra = 10;          % Doctors must exceed nurses by at least this many hours

% NOTE: Specific weekly bounds are not provided in the prompt.
% Use safe non-negative bounds implied by the overwork constraint to keep the model bounded.
int: max_doctor_hours = max_overwork;        % From doctor_hours + 3*nurse_hours <= 150 => doctor_hours <= 150
int: max_nurse_hours  = max_overwork div 3;  % From doctor_hours >= 0 => 3*nurse_hours <= 150 => nurse_hours <= 50

% Variables
var 0..max_doctor_hours: doctor_hours;  % Total weekly doctor hours (integer, non-negative)
var 0..max_nurse_hours:  nurse_hours;   % Total weekly nurse hours (integer, non-negative)

var 0..(doctor_cost_per_hour*max_doctor_hours
      + nurse_cost_per_hour*max_nurse_hours): total_cost; % Total staffing cost (bounded)

% Constraints
% Care effort requirement: ensure adequate patient care coverage
constraint 2 * doctor_hours + nurse_hours >= min_care_effort;

% Overwork limit: prevent excessive combined workload
constraint doctor_hours + 3 * nurse_hours <= max_overwork;

% Staffing mix requirement: doctors must exceed nurses by at least a fixed margin
constraint doctor_hours >= nurse_hours + min_doctor_extra;

% Total cost calculation: link total_cost to chosen hours and hourly costs
constraint total_cost = doctor_cost_per_hour * doctor_hours
                      + nurse_cost_per_hour  * nurse_hours;

% Objective
solve minimize total_cost;