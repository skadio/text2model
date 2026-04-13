% Data (embedded)
int: allergy_rate_f1 = 20;
int: fever_rate_f1   = 15;
int: allergy_rate_f2 = 10;
int: fever_rate_f2   = 30;

int: compound_f1 = 20;
int: compound_f2 = 30;
int: compound_available = 1000;

int: allergy_min = 700;
int: fever_min   = 600;

% Decision variables: hours run at each factory (use integer hours to avoid LP timeout on CP backends)
int: HMAX = compound_available div min(compound_f1, compound_f2); % safe upper bound
var 0..HMAX: h1;
var 0..HMAX: h2;

% Constraints
constraint allergy_rate_f1 * h1 + allergy_rate_f2 * h2 >= allergy_min;
constraint fever_rate_f1   * h1 + fever_rate_f2   * h2 >= fever_min;
constraint compound_f1 * h1 + compound_f2 * h2 <= compound_available;

% Objective: minimize total time
solve minimize h1 + h2;

output [
  "h1=", show(h1), "\n",
  "h2=", show(h2), "\n",
  "total_time=", show(h1 + h2), "\n"
];