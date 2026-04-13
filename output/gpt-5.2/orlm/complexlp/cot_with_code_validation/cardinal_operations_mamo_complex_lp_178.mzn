% Weekly night-shift staffing (LP relaxation)
int: D = 7;
set of int: Days = 1..D;

array[Days] of float: demand = [2.0, 4.0, 4.0, 3.0, 1.0, 2.0, 3.0];

int: L = 5; % consecutive working days per nurse

% Use bounded floats to avoid solver float-linear limits
float: UB = sum(j in Days)(demand[j]); % safe upper bound
array[Days] of var 0.0..UB: x;         % nurses starting a 5-day block on day i (cyclic)
var 0.0..UB: total_nurses;

% Coverage: day j is covered by nurses who started in the last L days (cyclic)
constraint forall(j in Days)(
  sum(k in 0..L-1)( x[ ((j - k - 1 + D) mod D) + 1 ] ) >= demand[j]
);

constraint total_nurses = sum(i in Days)(x[i]);

solve minimize total_nurses;

output [
  "total_nurses=", show(total_nurses), "\n",
  "rounded=", show(round(total_nurses)), "\n",
  "x=", show(x), "\n"
];