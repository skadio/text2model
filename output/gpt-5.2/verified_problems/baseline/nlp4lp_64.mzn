int: I; % Number of projects
int: J; % Number of consultants

array[1..J] of int: FixedCosts; % Fixed cost for hiring consultant j
array[1..I, 1..J] of int: AdditionalCosts; % Cost of assigning project i to consultant j

int: MaxProjectsPerConsultant; % Max number of projects per consultant

array[1..I, 1..J] of var 0..1: x; % x[i,j]=1 if project i assigned to consultant j
array[1..J] of var 0..1: y;       % y[j]=1 if consultant j is hired

% Each project assigned to exactly one consultant
constraint
  forall(i in 1..I) (
    sum(j in 1..J)(x[i,j]) = 1
  );

% Linking: can only assign projects to hired consultants
constraint
  forall(i in 1..I, j in 1..J) (
    x[i,j] <= y[j]
  );

% Capacity: max projects per consultant
constraint
  forall(j in 1..J) (
    sum(i in 1..I)(x[i,j]) <= MaxProjectsPerConsultant
  );

var int: TotalCost =
  sum(j in 1..J)(FixedCosts[j] * y[j]) +
  sum(i in 1..I, j in 1..J)(AdditionalCosts[i,j] * x[i,j]);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "HiredConsultants(y)=", show(y), "\n",
  "Assignments(x):\n"
] ++
[
  "Project " ++ show(i) ++ " -> Consultant " ++
  show(sum(j in 1..J)(j * x[i,j])) ++ "\n"
  | i in 1..I
];