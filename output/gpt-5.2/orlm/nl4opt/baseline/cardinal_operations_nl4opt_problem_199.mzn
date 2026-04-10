% Advertising allocation across streaming platforms
% Maximize audience reach subject to budget and mix constraints.

int: budget = 20000;

set of int: P = 1..3;
int: Pi = 1;
int: Beta = 2;
int: Gamma = 3;

array[P] of int: cost = [1200, 2000, 4000];
array[P] of int: reach = [2000, 5000, 9000];

var 0..budget div cost[Pi]: x_pi;
var 0..8: x_beta;
var 0..budget div cost[Gamma]: x_gamma;

var int: total_ads = x_pi + x_beta + x_gamma;

% Budget constraint
constraint cost[Pi]*x_pi + cost[Beta]*x_beta + cost[Gamma]*x_gamma <= budget;

% Mix constraints:
% At most a third of all commercials on Gamma: x_gamma <= total_ads/3  => 3*x_gamma <= total_ads
constraint 3 * x_gamma <= total_ads;

% At least 20% on Pi: x_pi >= 0.2*total_ads  => 5*x_pi >= total_ads
constraint 5 * x_pi >= total_ads;

% Avoid the degenerate case of zero commercials (not needed for maximizing reach, but safe)
constraint total_ads >= 1;

var int: total_reach = reach[Pi]*x_pi + reach[Beta]*x_beta + reach[Gamma]*x_gamma;

solve maximize total_reach;

output [
  "Pi TV commercials = ", show(x_pi), "\n",
  "Beta Video commercials = ", show(x_beta), "\n",
  "Gamma Live commercials = ", show(x_gamma), "\n",
  "Total commercials = ", show(total_ads), "\n",
  "Total cost = ", show(cost[Pi]*x_pi + cost[Beta]*x_beta + cost[Gamma]*x_gamma), "\n",
  "Total audience reach = ", show(total_reach), "\n"
];