% Parameters
int: I;                                        % Number of projects
int: J;                                        % Number of consultants
array[1..J] of int: FixedCosts;                % Fixed cost per consultant
array[1..I, 1..J] of int: AdditionalCosts;     % Additional assignment cost
int: MaxProjectsPerConsultant;                 % Capacity per consultant

set of int: Projects = 1..I;
set of int: Consultants = 1..J;

% Variables
array[Projects, Consultants] of var 0..1: x;   % 1 if project i assigned to consultant j
array[Consultants]            of var 0..1: y;   % 1 if consultant j is hired
var int: TotalCost;                             % Objective value

% Constraints
constraint
  forall(i in Projects)(
    sum(j in Consultants)(x[i,j]) = 1           % Each project assigned once
  );

constraint
  forall(j in Consultants)(
    sum(i in Projects)(x[i,j]) <= MaxProjectsPerConsultant   % Capacity
  );

constraint
  forall(j in Consultants, i in Projects)(
    x[i,j] <= y[j]                              % Link assignment to hiring
  );

constraint
  TotalCost =                                    % Cost calculation
    sum(j in Consultants)(FixedCosts[j] * y[j]) +
    sum(i in Projects, j in Consultants)(AdditionalCosts[i,j] * x[i,j]);

% Objective
solve minimize TotalCost;