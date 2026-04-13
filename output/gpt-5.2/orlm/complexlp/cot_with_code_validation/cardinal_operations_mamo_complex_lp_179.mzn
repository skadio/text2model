% Weekly night-shift staffing with 5 consecutive workdays (cyclic week)
int: D = 7;
set of int: DAYS = 1..D;
int: WORK = 5;

array[DAYS] of float: demand = [5.0, 4.0, 7.0, 3.0, 8.0, 4.0, 3.0];

% Use bounded float vars to avoid Gecode Float::linear limits
float: UB = sum(j in DAYS)(demand[j]);

array[DAYS] of var 0.0..UB: start;   % nurses starting on day s (works s..s+4 mod 7)
var 0.0..UB: total_nurses;

% Demand coverage: day j is covered by starts in {j, j-1, ..., j-4} mod 7
constraint
  forall(j in DAYS)(
    sum(k in 0..WORK-1)(
      start[ ((j - k - 1 + D) mod D) + 1 ]
    ) >= demand[j]
  );

constraint total_nurses = sum(s in DAYS)(start[s]);

solve minimize total_nurses;

% Rounded-to-nearest-integer answer (as requested)
output [
  "total_nurses = ", show(total_nurses), "\n",
  "rounded_total_nurses = ", show(round(total_nurses)), "\n",
  "start = ", show(start), "\n"
];