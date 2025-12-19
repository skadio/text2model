% Workforce Management for a Popsicle Stand
% Minimizing staffing cost while meeting daily staffing demand over a recurring period.
% Two types of workers:
%   - Full time: works full_time_shift consecutive days; cost per day = full_time_pay.
%   - Part time: works part_time_shift consecutive days; cost per day = part_time_pay.
%
% Data inputs (provided via a .dzn file):
%   int: n;                               % Number of days in the recurring period (indexed 0..n-1)
%   array[0..n-1] of int: demand;           % Required staff per day
%   int: full_time_pay;                    % Daily cost for full time worker
%   int: part_time_pay;                    % Daily cost for part time worker
%   int: full_time_shift;                  % Number of consecutive working days for a full time worker
%   int: part_time_shift;                  % Number of consecutive working days for a part time worker

% Decision variables:
% ft[d]  = number of full time workers whose shift starts at day d 
% pt[d]  = number of part time workers whose shift starts at day d 
% (The scheduling is cyclic, so a shift starting on day d covers days d, d+1, ..., d+shift-1 modulo n)

int: MaxStaff = 10000;  % An upper bound for the number of new hires starting on any day

array[0..n-1] of var 0..MaxStaff: ft;  % Full time hires starting on day d
array[0..n-1] of var 0..MaxStaff: pt;  % Part time hires starting on day d

% For each day d, compute the coverage of workers from shifts started on earlier days.
% A worker starting on day i is on duty on day d if ((d - i) mod n) < shift_length.
constraint
  forall(d in 0..n-1) (
    let {
      var int: fullCoverage = sum(i in 0..n-1)( if ((d - i) mod n) < full_time_shift then ft[i] else 0 ),
      var int: partCoverage = sum(i in 0..n-1)( if ((d - i) mod n) < part_time_shift then pt[i] else 0 )
    } in
      fullCoverage + partCoverage >= demand[d]
  );

% Calculate total cost:
%  For each full time worker hired, cost = full_time_pay * full_time_shift.
%  For each part time worker hired, cost = part_time_pay * part_time_shift.
var int: totalCost = full_time_pay * full_time_shift * sum(i in 0..n-1)(ft[i])
                   + part_time_pay * part_time_shift * sum(i in 0..n-1)(pt[i]);

solve minimize totalCost;

output [
  "Full-time hires (per starting day 0..", show(n-1), "): ", show(ft), "\n",
  "Part-time hires (per starting day 0..", show(n-1), "): ", show(pt), "\n",
  "Total cost: ", show(totalCost), "\n"
];