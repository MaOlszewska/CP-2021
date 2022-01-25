int: nr; % number of reclaimers
           % number of rails = nr for stages A,B,C,D,E
           % number of rails = (nr + 1) div 2 for stage F
set of int: RECLAIMER = 1..nr;
bool: stageF; % is this stage F data

int: ns; % number of stockpiles
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size in 10000 tonnes
array[STOCKPILE] of SHIP: ship; % which ship carries stockpile
 
int: maxtime; % time considered
set of int: TIME = 0..maxtime;

int: nsh; % number of ships
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when ship arrives in port

int: len; % length of pad
set of int: POSITION = 0..len;

int: stack_time;
int: reclaim_time;
int: reclaim_speed;

array[STOCKPILE] of var POSITION: westend;
array[STOCKPILE] of var POSITION: eastend;
array[STOCKPILE] of var TIME: stack;
array[STOCKPILE] of var TIME: endstack;
array[STOCKPILE] of var TIME: reclaim;
array[STOCKPILE] of var TIME: finished;
array[STOCKPILE] of var RECLAIMER: which;


array[SHIP] of var TIME: time_spent;
% Go crazy here

% Stage A - Packing Problem
% Two stockpiles can't overlap in "spacetime"
%constraint forall([which[i] == 1 | i in STOCKPILE]);

% 1) what's the relation between endstack and stack times
constraint forall([stack[i] + size[i] * stack_time = endstack[i]| i in STOCKPILE]);

% 2) what's the relation between finished and stack times
constraint forall([stack[i] < finished[i] | i in STOCKPILE]);    % dziwne

% 3) what's the relation between reclaim and endstack times
constraint forall([reclaim[i] >= endstack[i] | i in STOCKPILE]);

% 4) what's the relation between finished and reclam times
constraint forall([finished[i] = reclaim[i] + size[i] * reclaim_time| i in STOCKPILE]);

% 5) what's the relation between eastend and westend offsets
constraint forall([westend[i] + size[i] = eastend[i] | i in STOCKPILE]);

% 6) packing problem

%    a) stockpiles should not overlap in "spacetime", treat them as rectangles
constraint forall(i,j in STOCKPILE where i < j)(eastend[i]<=westend[j] \/ eastend[j]<=westend[i]\/finished[i]<=stack[j]\/finished[j]<=stack[i]);
%    b) stockpiles can't use more space than there is available
constraint forall(i in STOCKPILE)(eastend[i] <= len /\ westend[i] >= 0); 
%    c) we can't go beyond the time limit ????
constraint forall(i in STOCKPILE)(finished[i]<=maxtime);
  
  
% Stage B 
% Two stockpiles reclaimed by the same reclaimer do not overlap in time
%
% Tip: write your first custom predicate, i.e.
% predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2) =
% <something something> ;
predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2, int: use_delay) =
  reclaim[s1] - abs(westend[s1] - westend[s2]) * reclaim_speed * use_delay >= finished[s2] \/
  reclaim[s2] - abs(westend[s1] - westend[s2]) * reclaim_speed * use_delay >= finished[s1];

constraint forall(i, j in STOCKPILE where i < j )(which[i] != which[j] \/ not_overlap(i, j, 1));

% Stage C
% 1) no stockpile can be reclaimed onto a ship before the arrival time of the ship
constraint forall(i in STOCKPILE)(reclaim[i] >= arrival[ship[i]]); 
% 2) also no two stockpiles can be reclaimed onto the same ship at the same time. Make sure these reclaims do not overlap in time.
constraint forall(i, j in STOCKPILE where i < j)(ship[i] != ship[j] \/ not_overlap(i, j, 0));
% TIP: reuse your "not_overlap" predicate

% Stage D
% Add constraints to your model to ensure that if a reclaimer finishes reclaiming a stockpile with westend at x and then has to start reclaiming a stockpile with westend at y there is at least |y − x| ∗ reclaim speed time between these two events.
% TIP: just make your "not_overlap" predicate smarter
% TIP: you can introduce local variables in the constraints/predicates
% let {
%  <local variables>
% } in <then something>


% Stage E
% Add a definition of the objective to your model and change the model to minimize this value.
% You may well need to significantly change your search strategy to get good solutions for the objective.

% TIP: definetely change the line below
var int: obj = sum(i in SHIP)(max([finished[j] | j in STOCKPILE where ship[j] = i]) - arrival[i]);


% Stage F
% Add constraints in your model so that the two reclaimers on rail i numbered 2i − 1 and 2i for i ∈ 1..nr div 2 remain so the western one 2i − 1 is never east of the eastern one 2i. Note they can legitimately be in the same position (this is for simplicity, its not very real). Note that if there are
% an odd number of reclaimers the last reclaimer is on its own rail and has no further constraints.
% TIP: do some "channeling" and model reclaimers' positions explicitely with a new array of variables.

constraint (not stageF) \/ forall(i, j in STOCKPILE where i < j /\ 
  which[j] mod 2 == 0 /\ which[i] + 1 = which[j] /\ (reclaim[i] > finished[j] \/ finished[i] < reclaim[j]))(eastend[j] <= westend[i]);

solve:: int_search([obj], input_order, indomain_min, complete) minimize obj;

%solve minimize obj;
% don't change the output
output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"] ++
["obj = ",show(obj), ";\n"]
;
