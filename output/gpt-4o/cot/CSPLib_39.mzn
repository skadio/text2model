% Parameters
int: num_pieces;
int: num_players;

set of int: Pieces  = 1..num_pieces;
set of int: Players = 1..num_players;

array[Pieces]          of int: duration;                    % duration of each piece
array[Players, Pieces] of int: rehearsal;                   % 1 if player p plays in piece i, 0 otherwise

int: total_duration = sum(i in Pieces)(duration[i]);        % useful upper-bound

array[Players] of int: playing_time =                       % fixed playing time of every player
    [ sum(i in Pieces)(rehearsal[p,i] * duration[i]) | p in Players ];

% Variables
array[Pieces]  of var Pieces: pos;            % position of every piece in the schedule
array[Players] of var Pieces: first_p;        % first piece a player is present
array[Players] of var Pieces: last_p;         % last  piece a player is present

array[Players, Pieces] of var bool: between;  % true if a piece occurs between first_p and last_p for player p

array[Players] of var 0..total_duration: present_time;
array[Players] of var 0..total_duration: waiting_time;

var int: total_waiting = sum(p in Players)(waiting_time[p]);

% Constraints
constraint
    all_different(pos);

% participating pieces must lie inside the personal interval
constraint
    forall(p in Players, i in Pieces where rehearsal[p,i] = 1)(
        first_p[p] <= pos[i] /\ pos[i] <= last_p[p]
    );

% interval consistency
constraint
    forall(p in Players)(
        first_p[p] <= last_p[p]
    );

% indicate whether a piece lies in a player’s interval
constraint
    forall(p in Players, i in Pieces)(
        between[p,i] = (first_p[p] <= pos[i] /\ pos[i] <= last_p[p])
    );

% compute presence time of every player
constraint
    forall(p in Players)(
        present_time[p] = sum(i in Pieces)(duration[i] * bool2int(between[p,i]))
    );

% waiting time definition
constraint
    forall(p in Players)(
        waiting_time[p] = present_time[p] - playing_time[p]
    );

% Objective
solve minimize total_waiting;