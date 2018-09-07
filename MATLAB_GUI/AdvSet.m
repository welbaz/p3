function AdvSet(Temp,TempEff,Zen,ZenEff,ZenDir,OhmEff,Dir)
%opens a window to insert some parameters related to
%the reduction factors of the PV system's efficiency

        
Advance=uifigure('Position',[100 100 692 234],'Name','Advanced Settings');

TitleLabel = uilabel(Advance,...
            'HorizontalAlignment','center','VerticalAlignment', 'center', ...
            'FontSize',16,'FontWeight','bold','Position', [183.5 193 345 20], ...
            'Text','Parameters affecting PV system''s efficiency');

ZenithdegLabel = uilabel(Advance,...
            'FontSize',14, 'Position',[37 147 83 18],...
            'Text','Zenith [deg]');

ZenDeg = uieditfield(Advance, 'numeric',...
            'Limits', [0 90], 'FontSize', 14, ...
            'Position', [163 144 70 22],'Value',Zen);
        
DDlabel = uilabel(Advance,...
            'VerticalAlignment', 'center', 'FontSize', 14,...
            'Position', [266 145 30 18],'Text', 'with');
        
ZenDirec = uidropdown(Advance);
            ZenDirec.Items = {'increasing', 'decreasing'};
            ZenDirec.FontSize = 14;
            ZenDirec.Position = [303 144 105 22];
            ZenDirec.Value = ZenDir;
            
    angleLabel = uilabel(Advance);
    angleLabel.FontSize = 14;
    angleLabel.Position = [420 147 40 18];
    angleLabel.Text = 'angle';

    LossesEditFieldLabel = uilabel(Advance);
    LossesEditFieldLabel.FontSize = 14;
    LossesEditFieldLabel.Position = [493 147 74 18];
    LossesEditFieldLabel.Text = 'Losses [%]';

    ZenLoss = uieditfield(Advance, 'numeric');
    ZenLoss.Limits = [0 100];
    ZenLoss.FontSize = 14;
    ZenLoss.Position = [593 145 63 22];
    ZenLoss.Value = (1-ZenEff)*100;

    TemperatureCLabel = uilabel(Advance);
    TemperatureCLabel.FontSize = 14;
    TemperatureCLabel.Position = [37 105 115 18];
    TemperatureCLabel.Text = 'Temperature [°C]';

    Temper = uieditfield(Advance, 'numeric');
    Temper.Limits = [0 90];
    Temper.FontSize = 14;
    Temper.Position = [163 102 70 22];
    Temper.Value = Temp;

    LossesEditField_2Label = uilabel(Advance);
    LossesEditField_2Label.FontSize = 14;
    LossesEditField_2Label.Position = [266 104 74 18];
    LossesEditField_2Label.Text = 'Losses [%]';

    TempLoss = uieditfield(Advance, 'numeric');
    TempLoss.Limits = [0 100];
    TempLoss.FontSize = 14;
    TempLoss.Position = [366 102 63 22];
    TempLoss.Value = (1-TempEff)*100;

    GenericLossesLabel = uilabel(Advance);
    GenericLossesLabel.FontSize = 14;
    GenericLossesLabel.Position = [37 64 140 18];
    GenericLossesLabel.Text = 'Generic Losses [%]';

    GenLoss = uieditfield(Advance, 'numeric');
    GenLoss.Limits = [0 100];
    GenLoss.FontSize = 14;
    GenLoss.Position = [163 61 70 22];
    GenLoss.Value = (1-OhmEff)*100;


    OkButton = uibutton(Advance, 'push');
    OkButton.FontSize = 16;
    OkButton.Position = [252 15 100 27];
    OkButton.Text = 'Ok';

    CancelButton = uibutton(Advance, 'push');
    CancelButton.FontSize = 16;
    CancelButton.Position = [380 15 100 27];
    CancelButton.Text = 'Cancel';
    
    OkButton.ButtonPushedFcn = @(OkButton,event)...
        OK(OkButton,Advance,Temper.Value,TempLoss.Value,ZenDeg.Value,ZenLoss.Value,GenLoss.Value, ZenDirec.Value, Dir);    
    CancelButton.ButtonPushedFcn = @(CancelButton,event) CANCEL(CancelButton,Advance);

    uiwait(Advance)
        
    
    
    function OK(OkButton,Advance,T,TLoss,Zdeg,ZLoss,GLoss,ZDir,Dir)
        AdvN=[T TLoss Zdeg ZLoss GLoss];
        save([Dir 'Advanced.mat'],'AdvN','ZDir');
        delete(Advance)
    end

    function CANCEL(CancelButton,Advance)
        delete(Advance)
    end

end