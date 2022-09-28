function processedEMG=EMG_process(rawEMG,fileName,window)

% % example inputs:
% rawEMG=m9;
% fileName='m9';
% window=0.05;

time1=rawEMG(:,1);
emg1=rawEMG(:,2); %Biceps

time2=rawEMG(:,15);
emg2=rawEMG(:,16); %Triceps

time3=rawEMG(:,29);
emg3=rawEMG(:,30); % Posterior Deltoid

time4=rawEMG(:,31);
emg4=rawEMG(:,32); % Medial Deltoid

time5=rawEMG(:,33);
emg5=rawEMG(:,34); % Anterior Deltoid

time6=rawEMG(:,35);
emg6=rawEMG(:,36); % Upper Trapezius

for ss=1:6
    emg_raw=eval(['emg' num2str(ss)]);
    time_raw=eval(['time' num2str(ss)]);
    
       
    % remove EMG =0 and nan
    i1=find(emg_raw==0);
    emg_raw(i1,1)=nan;
    i0=~isnan(emg_raw);

    EMG=emg_raw(i0,1);
    TIME=time_raw(i0,1);


    % sampling frequency
     Frq=1/((TIME(3)-TIME(2)));

     filtemg=EMG_filter_bandonly(EMG,Frq); % filter EMG
     eval(['filtemg' num2str(ss) '=filtemg;']);
     eval(['fs' num2str(ss) '=Frq;']);
     eval(['filtTime' num2str(ss) '=TIME;']);
     
     clear filtemg Frq EMG TIME i1 i0
end


%% process six muscle together

[time_y1, Emg1]=EMG_RecRms(filtemg1,filtTime1,fs1, fs1*window, 0, 0); % rectify and RMS
[time_y2, Emg2]=EMG_RecRms(filtemg2,filtTime2,fs2, fs2*window, 0, 0); % rectify and RMS
[time_y3, Emg3]=EMG_RecRms(filtemg3,filtTime3,fs3, fs3*window, 0, 0); % rectify and RMS
[time_y4, Emg4]=EMG_RecRms(filtemg4,filtTime4,fs4, fs4*window, 0, 0); % rectify and RMS
[time_y5, Emg5]=EMG_RecRms(filtemg5,filtTime5,fs5, fs5*window, 0, 0); % rectify and RMS
[time_y6, Emg6]=EMG_RecRms(filtemg6,filtTime6,fs6, fs6*window, 0, 0); % rectify and RMS

winName=num2str(window);
winName2=split(winName,'.'); % obtain label for window size (e.g., if window=0.05, the plot name will include "05")

figure(1)
plot(time_y1, Emg1,'r',time_y2, Emg2,'b',time_y3, Emg3,'k',time_y4, Emg4,'m',time_y5, Emg5,'g',time_y6, Emg6,'c')
legend('Biceps','Triceps','Posterior Deltoid','Medial Deltoid','Anterior Deltoid','Upper Trapezius')
xlabel('Time (s)')
ylabel('EMG (processed), mV')
% ylim([-0.003,0.003])
set(gcf,'Color',[1,1,1])
title([fileName, ' processed EMG'])
saveas(gcf,[fileName, ' processed EMG_w' winName2{2,1}],'jpg')
% close all

Length=min([length(time_y1),length(time_y2),length(time_y3),length(time_y4),length(time_y5),length(time_y6)]); % make the EMG data at the same length
for qq=1:6
    eval(['time_y' num2str(qq) '=time_y' num2str(qq) '(1:Length);'])
    eval(['Emg' num2str(qq) '=Emg' num2str(qq) '(1:Length);'])
end

%processedEMG=[time_y1',Emg1',time_y2',Emg2',time_y3',Emg3',time_y4',Emg4',time_y5',Emg5',time_y6',Emg6'];
processedEMG=[time_y1',Emg1',Emg2',Emg3',Emg4',Emg5',Emg6'];

