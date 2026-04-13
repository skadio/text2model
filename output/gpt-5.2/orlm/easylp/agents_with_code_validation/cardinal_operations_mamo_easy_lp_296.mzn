% Parameters
int: min_teachers = 5;          % Minimum number of teachers required
int: min_assistants = 3;        % Minimum number of assistants required
int: min_staff = 2;             % Minimum number of staff required
int: max_total_hires = 15;      % Maximum total hires allowed (budget constraint)

int: cost_teacher = 20;         % Cost per teacher hire (units)
int: cost_assistant = 10;       % Cost per assistant hire (units)
int: cost_staff = 5;            % Cost per staff hire (units)

% Variables
var min_teachers..max_total_hires: n_teachers;      % Number of teachers to hire
var min_assistants..max_total_hires: n_assistants;  % Number of assistants to hire
var min_staff..max_total_hires: n_staff;            % Number of staff to hire

% Upper bound: all hires at max_total_hires in each category (loose but safe)
var 0..(cost_teacher*max_total_hires
      + cost_assistant*max_total_hires
      + cost_staff*max_total_hires): total_cost;    % Total hiring cost (units)

% Constraints
% --- Minimum staffing requirements (already enforced by variable domains) ---
% Kept as explicit constraints for clarity/robustness.
constraint n_teachers   >= min_teachers;
constraint n_assistants >= min_assistants;
constraint n_staff      >= min_staff;

% --- Total hires must not exceed the maximum allowed ---
constraint n_teachers + n_assistants + n_staff <= max_total_hires;

% --- Define total cost from per-role costs and hire counts ---
constraint total_cost =
  cost_teacher   * n_teachers +
  cost_assistant * n_assistants +
  cost_staff     * n_staff;

% Objective
solve minimize total_cost;