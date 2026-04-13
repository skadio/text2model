% Soda delivery van selection (embed all data directly)

% Data
int: cap_old = 100;      % bottles per old van
int: cap_new = 80;       % bottles per new van
int: pol_old = 50;       % pollution per old van
int: pol_new = 30;       % pollution per new van
int: demand  = 5000;     % minimum bottles to send
int: max_new = 30;       % maximum number of new vans

% Decision variables
% Upper bounds are safe maxima for feasibility; old vans alone could meet demand.
var 0..(demand div cap_old + 100): oldVans;
var 0..max_new: newVans;

% Constraints
constraint cap_old * oldVans + cap_new * newVans >= demand;

% Objective: minimize total pollution
var int: totalPollution = pol_old * oldVans + pol_new * newVans;

solve minimize totalPollution;

output [
  "oldVans = ", show(oldVans), "\n",
  "newVans = ", show(newVans), "\n",
  "bottlesSent = ", show(cap_old * oldVans + cap_new * newVans), "\n",
  "totalPollution = ", show(totalPollution), "\n"
];