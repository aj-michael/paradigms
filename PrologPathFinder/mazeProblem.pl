% Part 1: Read section 4.2 in your textbook
%
% Part 2: Write a simple prolog pathfinder

% Here's some example data: 
% c stands for 'connected'
c(1,2). % so node 1 and node 2 are connected
c(1,3).
c(2,4).
c(3,4).
c(1,6).

% Write a function findPath that takes a start node, end node and computes
% a path between the start node and the end node.  Note that this need
% not be the *shortest* path, just a path if one exists.
%
% ?- [mazeProblem].
% mazeProblem compiled 0.00 sec, 15 clauses
% true.
%
% ?- findPath(1,4,Path).
% Path = [1, 2, 4] ;
% Path = [1, 3, 4] ;
% false.
%
% Part A. 15 points. You can assume no cycles, and edges are directed
%
% To help me write this solution, I wrote a helper function
% findPathHelper that took 3 parameters: the endnode, a reverse
% ordered list of all the nodes in my current path, and the
% final result.  If you use my approach, you'll want to know
% prolog has a built in reverse function for reversing a list.
%
% bonus hint: here's my base case for that solution:
% findPathHelper(Last,[Last|Rest], [Last|Rest]).
%
% You do not need to use my approach though. :D


% Part B. 15 points. Now your source graph may have cycles.  You don't
% need to think about solutions that revisit a node (remember
% that in prolog your code might return more than one result
% so that actually might be a concern) but something like this:

c(10,11).
c(11,12).
c(12,10).
c(12,13).

% should not get stuck in an infinte loop if I ask for
% a path from 10 to 13.

% Part C.  Make it so that the c(X,Y) predicate produces
% an undirected edge.  Note that you shouldn't just add a
% bunch of additional data - instead modify your code so
% that edges are treated like they go both directions
% regardless of the order they are specified in.


% Your awesome code here!


% % % % % % % % % % % % %
% My answer to Part A:  %
% % % % % % % % % % % % %
%
% findPath(End,End,Path) :- Path = [End].
% findPath(Start,End,Path) :- c(Start,Other), findPath(Other,End,Rest), Path = [Start|Rest].

% % % % % % % % % % % % %
% My answer to Part B:  %
% % % % % % % % % % % % %
% 
%findPath(Start,End,Path) :- findPathHelper(End,[Start],BackwardsPath), reverse(Path,BackwardsPath).
%findPathHelper(End,[End|Rest],[End|Rest]).
%findPathHelper(End,[Current|Previous],Path) :- 
%    c(Current,Next), 
%    \+member(Next,[Current|Previous]), 
%    findPathHelper(End,[Next|[Current|Previous]],Path).


% % % % % % % % % % % % %
% My answer to Part C:  %
% % % % % % % % % % % % %
findPath(Start,End,Path) :- findPathHelper(End,[Start],BackwardsPath), reverse(Path,BackwardsPath).
findPathHelper(End,[End|Rest],[End|Rest]).
findPathHelper(End,[Current|Previous],Path) :- 
    (c(Current,Next); c(Next,Current)),
    \+member(Next,[Current|Previous]), 
    findPathHelper(End,[Next|[Current|Previous]],Path).
