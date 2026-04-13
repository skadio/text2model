% Mountain transport pollution minimization
% Data embedded as required.

int: cap_balloon = 4;
int: cap_gondola = 6;

int: pol_balloon = 10;
int: pol_gondola = 15;

int: max_balloon = 10;
int: min_visitors = 70;

% Decision variables
var 0..max_balloon: balloons;
% Upper bound: if balloons = 0, need ceil(70/6)=12 gondolas; safe upper bound 100.
var 0..100: gondolas;

% Constraints
constraint cap_balloon * balloons + cap_gondola * gondolas >= min_visitors;

% Objective: minimize total pollution
var int: total_pollution = pol_balloon * balloons + pol_gondola * gondolas;

solve minimize total_pollution;

output [
  "balloons = ", show(balloons), "\n",
  "gondolas = ", show(gondolas), "\n",
  "visitors_transported = ", show(cap_balloon * balloons + cap_gondola * gondolas), "\n",
  "total_pollution = ", show(total_pollution), "\n"
];