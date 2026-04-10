% Concert planning: minimize total number of concerts

int: audience_pop = 100;
int: days_pop = 2;

int: audience_rnb = 240;
int: days_rnb = 4;

int: min_audience = 10000;
int: max_days = 180;

% Decision variables: number of concerts of each type
var 0..10000: pop;
var 0..10000: rnb;

% Total audience requirement
constraint audience_pop * pop + audience_rnb * rnb >= min_audience;

% Practice days limit
constraint days_pop * pop + days_rnb * rnb <= max_days;

% At most 40% of concerts can be R&B:
% rnb / (pop + rnb) <= 0.4  <=>  5*rnb <= 2*(pop + rnb)  <=>  3*rnb <= 2*pop
constraint 3 * rnb <= 2 * pop;

% Need at least one concert if audience requirement is positive
constraint pop + rnb >= 1;

solve minimize pop + rnb;

output [
  "pop = ", show(pop), "\n",
  "rnb = ", show(rnb), "\n",
  "total_concerts = ", show(pop + rnb), "\n",
  "total_audience = ", show(audience_pop * pop + audience_rnb * rnb), "\n",
  "total_days = ", show(days_pop * pop + days_rnb * rnb), "\n"
];