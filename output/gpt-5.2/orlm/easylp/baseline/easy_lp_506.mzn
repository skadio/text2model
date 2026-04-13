% Marketing campaign budget allocation (all data embedded)

% Decision variables: effort units in each channel (integers)
var 0..800: online;
var 0..700: offline;
var 0..600: event;

% Costs per unit of effectiveness (dollars per unit)
int: c_online = 50;
int: c_offline = 70;
int: c_event = 90;

% Constraints
constraint online + offline + event >= 1000;

% |online - 0.5*offline| <= 500  -> multiply by 2 to keep integers:
% |2*online - offline| <= 1000
constraint abs(2*online - offline) <= 1000;

% Offline at least 200 more than event
constraint offline - event >= 200;

% Online + event cannot exceed 1200
constraint online + event <= 1200;

% Objective: minimize total cost
var int: total_cost = c_online*online + c_offline*offline + c_event*event;
solve minimize total_cost;

output [
  "online = ", show(online), "\n",
  "offline = ", show(offline), "\n",
  "event = ", show(event), "\n",
  "total_cost = $", show(total_cost), "\n"
];