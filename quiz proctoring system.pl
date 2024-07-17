tah([],_,[]).
tah([ta(Name,Day_off)|T],DayName,[Name|L]):-
	Day_off\=DayName,
	tah(T,DayName,L).
tah([ta(_, Day_off)|T],DayName,L):-
	Day_off=DayName,
	tah(T,DayName,L).

helper(_,day(_,[]),day(_,[]),_).
helper(ALLTAs,day(DayName,[H|T2]),day(DayName,[H2|T3]),L) :-
	subtract(L,H,H1),
	permutation(H1,H2),
	helper(ALLTAs,day(DayName,T2),day(DayName,T3),L).

free_schedule(_,[],[]).
free_schedule(ALLTAs, [day(DayName, DaySchedule)|T1],[day(DayName, DaySchedulefree)|T4]) :-
	tah(ALLTAs,DayName,L),
	helper(ALLTAs,day(DayName,DaySchedule),day(DayName,DaySchedulefree),L),
	free_schedule(ALLTAs,T1,T4).
assign_quiz([],_,[]).
assign_quiz(quiz(Course, DayName, Slot, Count), [day(DayName, DaySchedule) | T], AssignedTAs) :-
    nth1(Slot, DaySchedule, ListTa),
    length(ListTa, L),
    helper1(ListTa, Count, L, AssignedTAs).
assign_quiz(quiz(Course, Day, Slot, Count), [day(DayName, _) | T], AssignedTAs) :-
    Day \= DayName,
    assign_quiz(quiz(Course, Day, Slot, Count), T, AssignedTAs).
helper1(ListTa, Count, L, AssignedTAs) :-
    L > Count,
    permutation(ListTa,Y),
    helplen(Count, Y, AssignedTAs).
helper1(ListTa, Count, L, AssignedTAs) :-
    L = Count,
    permutation(ListTa, AssignedTAs).

helplen(0,_,[]).
helplen(Count, [H|T],[H|L]) :-
	Count>0,
	Count1 is Count -1,
	helplen(Count1,T,L).


update([],_,_,[]).
update([day(DayName,DaySchdeule)|T],AssignedTAs,quiz(Course, DayName1, Slot, Count),[day(DayName,DaySchdeule)|T2]):-
	DayName\=DayName1,
	update(T,AssignedTAs,quiz(Course, DayName1, Slot, Count),T2).	

update([day(DayName,DaySchdeule)|T],AssignedTAs,quiz(Course, DayName, Slot, Count),[day(DayName,R)|T2]):-
		helpslot(DaySchdeule,Slot,1,R),
		update(T,AssignedTAs,quiz(Course,DayName,Slot,Count),T2).	
helpslot([],_,_,[]).		
helpslot([X|Y],Slot,C,[X|Y1]):-
	Slot\=C,
	C1 is C+1,
	helpslot(Y,Slot,C1,Y1).

helpslot([X|Y],Slot,C,[Res|Y1]):-
	Slot=C,	
	subtract(X,AssignedTAs,Res),
	C1 is C+1,
	helpslot(Y,Slot,C1,Y1).
	
assign_quizzes([],_,[]).	
assign_quizzes([quiz(Course, Day, Slot, Count)|T1],FreeSchedule,[proctors(quiz(Course, Day, Slot, Count),AssignedTAs)|T4]):-
	assign_quiz(quiz(Course, Day, Slot, Count),FreeSchedule,AssignedTAs),
	update(FreeSchedule,AssignedTAs,quiz(Course, Day, Slot, Count),NewSchedule),
	assign_quizzes(T1,NewSchedule,T4).




assign_proctors(ALLTAs,Quizzes,TeachingSchedule,P):-
	free_schedule(ALLTAs, TeachingSchedule,FreeSchedule),!,
	assign_quizzes(Quizzes,FreeSchedule,P).

	
	

	
	
	
	
