int: nDays = 7;
set of int: Days = 1..nDays;

array[Days] of float: d = [2.0, 4.0, 4.0, 3.0, 1.0, 2.0, 3.0];

% x[s] = number of nurses (possibly fractional) whose 5-day block starts on day s
array[Days] of var float: x;
constraint forall(s in Days)(x[s] >= 0.0);

% Coverage: a nurse starting on day s works days s..s+4 (mod 7)
constraint
  forall(j in Days)(
    sum(s in Days where ((j - s + nDays) mod nDays) <= 4)( x[s] ) >= d[j]
  );

var float: totalNurses = sum(s in Days)(x[s]);

solve minimize totalNurses;

% Rounded to nearest integer (half-up)
var int: totalRounded = if totalNurses >= 0.0 then
  floor(totalNurses + 0.5)
else
  -floor(-totalNurses + 0.5)
endif;

output [
  "Total nurses (fractional optimum) = ", show(totalNurses), "\n",
  "Total nurses (rounded) = ", show(totalRounded), "\n",
  "Start-day nurses x[1..7] = ", show(x), "\n"
];