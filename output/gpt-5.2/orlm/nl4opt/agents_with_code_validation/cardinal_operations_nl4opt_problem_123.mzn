% Parameters
int: total_mrna_mg = 20000;                 % Total available mRNA (mg)

int: mrna_per_child_mg = 50;               % mRNA per children's vaccine (mg)
int: suppressant_per_child_mg = 50;        % Fever suppressant per children's vaccine (mg)

int: mrna_per_adult_mg = 75;               % mRNA per adult vaccine (mg)
int: suppressant_per_adult_mg = 75;        % Fever suppressant per adult vaccine (mg)

float: min_adult_fraction = 0.70;          % At least 70% of vaccines must be adult
int: min_children_vaccines = 50;           % At least 50 children's vaccines must be made

% Derived bounds (safe upper bounds from mRNA availability)
int: max_children_by_mrna = total_mrna_mg div mrna_per_child_mg;
int: max_adult_by_mrna = total_mrna_mg div mrna_per_adult_mg;

% Helper function to give a simple safe upper bound for suppressant_used (mg)
function int: suppression_bound(int: total_mrna, int: supp_child, int: supp_adult) =
  total_mrna * max(supp_child, supp_adult);

% Variables
var 0..max_children_by_mrna: num_children;  % Number of children's vaccines produced
var 0..max_adult_by_mrna:    num_adults;    % Number of adult vaccines produced

var 0..total_mrna_mg: mrna_used;            % Total mRNA used (mg)
var 0..suppression_bound(total_mrna_mg, suppressant_per_child_mg, suppressant_per_adult_mg): suppressant_used;
% Total fever suppressant used (mg)

% Constraints

%--- mRNA usage accounting and capacity ---------------------------------------
% Define total mRNA used based on produced vaccines
constraint mrna_used =
  mrna_per_child_mg * num_children + mrna_per_adult_mg * num_adults;

% Cannot exceed available mRNA
constraint mrna_used <= total_mrna_mg;

%--- Fever suppressant usage accounting ----------------------------------------
% Define total fever suppressant used based on produced vaccines
constraint suppressant_used =
  suppressant_per_child_mg * num_children + suppressant_per_adult_mg * num_adults;

%--- Minimum production requirements -------------------------------------------
% At least the required number of children's vaccines
constraint num_children >= min_children_vaccines;

%--- Adult fraction requirement (avoid floats by cross-multiplying) ------------
% num_adults / (num_adults + num_children) >= min_adult_fraction
% Equivalent: 100*num_adults >= 70*(num_adults + num_children)
constraint 100 * num_adults >= 70 * (num_adults + num_children);

% Objective
solve minimize suppressant_used;