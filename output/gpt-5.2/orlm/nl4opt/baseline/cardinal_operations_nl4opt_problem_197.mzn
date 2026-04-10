% Vaccine production optimization: minimize gelatine usage

% Data (embedded)
int: antibiotics_available = 35000;

int: abx_first = 30;
int: gel_first = 20;   % mg per first-dose

int: abx_second = 65;
int: gel_second = 60;  % mg per second-dose

int: min_second = 40;

% Decision variables
var 0..antibiotics_available div abx_first: first;
var 0..antibiotics_available div abx_second: second;

% Constraints
constraint abx_first * first + abx_second * second <= antibiotics_available;
constraint first > second;          % must be more first-dose than second-dose
constraint second >= min_second;    % at least 40 second-dose vaccines

% Objective: minimize total gelatine used (mg)
var int: total_gel = gel_first * first + gel_second * second;
solve minimize total_gel;

output [
  "first_dose=", show(first), "\n",
  "second_dose=", show(second), "\n",
  "total_gelatine_mg=", show(total_gel), "\n",
  "antibiotics_used=", show(abx_first*first + abx_second*second), "\n"
];