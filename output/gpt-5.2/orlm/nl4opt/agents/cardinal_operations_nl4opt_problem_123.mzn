% Parameters
int: total_mrna_mg = 20000;                 % Total available mRNA (mg)

int: mrna_per_child_mg = 50;                % mRNA needed per children's vaccine (mg)
int: suppressant_per_child_mg = 50;         % Fever suppressant per children's vaccine (mg)

int: mrna_per_adult_mg = 75;                % mRNA needed per adult vaccine (mg)
int: suppressant_per_adult_mg = 75;         % Fever suppressant per adult vaccine (mg)

float: min_adult_fraction = 0.70;           % At least this fraction of all vaccines must be adult
int: min_children_vaccines = 50;            % Minimum number of children's vaccines

% Upper bounds derived from mRNA limit (safe integer bounds)
int: max_children = total_mrna_mg div mrna_per_child_mg;  % if only children were made
int: max_adult = total_mrna_mg div mrna_per_adult_mg;     % if only adults were made

% Precompute percent form to avoid float/int coercion in constraints
int: min_adult_percent = int_round(min_adult_fraction * 100.0);

% Variables
var 0..max_children: num_children;          % Number of children's vaccines to produce
var 0..max_adult: num_adults;               % Number of adult vaccines to produce

var 0..total_mrna_mg: total_suppressant_mg; % Total fever suppressant used (mg)

% Constraints

% --- Resource constraint: total mRNA usage cannot exceed availability ---
constraint
  mrna_per_child_mg * num_children + mrna_per_adult_mg * num_adults
  <= total_mrna_mg;

% --- Policy constraint: produce at least the minimum number of children's vaccines ---
constraint
  num_children >= min_children_vaccines;

% --- Policy constraint: at least min_adult_fraction of all vaccines are adult ---
% num_adults / (num_children + num_adults) >= min_adult_fraction
% <=> (1 - f) * num_adults >= f * num_children
% Using integer percentage arithmetic:
constraint
  (100 - min_adult_percent) * num_adults >= min_adult_percent * num_children;

% --- Definition constraint: total fever suppressant used (mg) ---
constraint
  total_suppressant_mg
  = suppressant_per_child_mg * num_children + suppressant_per_adult_mg * num_adults;

% Objective
solve minimize total_suppressant_mg;