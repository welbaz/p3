function Time=timestruct(timein,UTC)
% Creates a timestructure
dummy=datevec(timein);
Time.year=dummy(1);
Time.month=dummy(2);
Time.day=dummy(3);
Time.hour=dummy(4);
Time.minute=dummy(5);
Time.second=dummy(6);
Time.UTC=UTC;
end