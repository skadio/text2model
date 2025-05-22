% Parameters
int: I;
int: J;

array [1..J] of int: FixedCosts;
array [1..I, 1..J] of int: AdditionalCosts;

int: MaxProjectsPerConsultant;

% Variables
array [1..I, 1..J] of var 0..1: x;            % 1 if project i is assigned to consultant j
array [1..J] of var 0..1: y;                  % 1 if consultant j is hired

var int: TotalCost;

% Constraints
constraint
    forall(i in 1..I) (
        sum(j in 1..J)( x[i,j] ) = 1          % each project is assigned to exactly one consultant
    );

constraint
    forall(j in 1..J) (
        sum(i in 1..I)( x[i,j] ) <= MaxProjectsPerConsultant * y[j]   % capacity & linking
    );

constraint
    TotalCost = 
        sum(j in 1..J)( FixedCosts[j] * y[j] ) +
        sum(i in 1..I, j in 1..J)( AdditionalCosts[i,j] * x[i,j] );

% Objective
solve minimize TotalCost;