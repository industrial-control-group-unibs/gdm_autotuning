%% Open communication port
function Out = OpenDriveConnection(Baudrate, Com)


    if(nargin < 1)
        Baudrate = 115200;
    end

    if(nargin < 2)
        ComSelection = 1;
    else
        ComSelection = 0;
    end

    %% COM SELECTION by USER
    if(ComSelection)
        if not(isempty(instrfindall))
            fclose(instrfindall);delete(instrfindall);
        end

        coms = instrhwinfo('serial');
        if isempty(coms.AvailableSerialPorts)
            %    errordlg('No serial ports available.','Serial port error');
            %    error('No serial ports available.');
            disp('No serial ports available.');
            if exist('DUT_addr_READ')
                clear ('DUT_addr_READ');
            end
        else
            if numel(coms.AvailableSerialPorts)>1
                [choice,ok] = listdlg('PromptString','Select one COM ports:',...
                    'SelectionMode','single',...
                    'ListString',coms.AvailableSerialPorts,'ListSize',[160,100]);
            else
                choice = 1;
                ok = 1;
            end
            if not(ok==1 & length(choice)==1)
                errordlg('One serial port must be selected.','Serial port error');
                error('One serial port must be selected.');
            else    % serial OK
                fprintf('\n---------------------------------------------------------\n');
                for k=1:length(choice)
                    com_ = strsplit(coms.AvailableSerialPorts{choice(k)},'COM');
                end
            end
        end
        com = cell2mat(com_(2));
    else
        k = 1;
        com = Com;
    end

    str = char(strcat('Modbus:1,1000,M#COM:',com,',',num2str(Baudrate),',N,8,1,H'));
    Out.e = actxserver('Modbus.Modbus.1');
    % IOut.Modbus = Out.e.interfaces
    Out.Modbus = invoke(Out.e,'IModbus');

    Out.e.Port = str2double(com);
    invoke(Out.Modbus,'Init',str);
    fprintf('\nConnecting to device #%d on COM: (%s) ...\n', k, com);
end
