function [predictedo measuredo Nancheck]=CleanData(predicted,measured)
Nancheck = ~isnan(measured) & ~isnan(predicted);
predictedo= predicted(Nancheck);
measuredo = measured(Nancheck);
end