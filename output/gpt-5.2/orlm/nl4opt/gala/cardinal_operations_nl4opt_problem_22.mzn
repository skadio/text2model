% Catalyst mix optimization (all data embedded)

% Data
int: platinum_available  = 450;
int: palladium_available = 390;

int: pd_platinum_req  = 15;
int: pd_palladium_req = 25;
int: pd_rate          = 5;   % units converted per second

int: pt_platinum_req  = 20;
int: pt_palladium_req = 14;
int: pt_rate          = 4;   % units converted per second

% Decision variables: number of each catalyst process used (nonnegative integers)
var 0..min(platinum_available div pd_platinum_req,
           palladium_available div pd_palladium_req): x_pd;  % palladium-heavy
var 0..min(platinum_available div pt_platinum_req,
           palladium_available div pt_palladium_req): x_pt;  % platinum-heavy

% Resource constraints
constraint pd_platinum_req * x_pd + pt_platinum_req * x_pt <= platinum_available;
constraint pd_palladium_req * x_pd + pt_palladium_req * x_pt <= palladium_available;

% Objective: maximize total conversion rate
var int: total_rate = pd_rate * x_pd + pt_rate * x_pt;

solve maximize total_rate;

output [
  "Palladium-heavy catalysts = ", show(x_pd), "\n",
  "Platinum-heavy catalysts  = ", show(x_pt), "\n",
  "Total conversion rate     = ", show(total_rate), " units/second\n",
  "Platinum used             = ", show(pd_platinum_req * x_pd + pt_platinum_req * x_pt),
  " / ", show(platinum_available), "\n",
  "Palladium used            = ", show(pd_palladium_req * x_pd + pt_palladium_req * x_pt),
  " / ", show(palladium_available), "\n"
];