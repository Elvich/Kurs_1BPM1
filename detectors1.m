close all;clear all;clc;

vidObj = VideoReader('/Users/elvich/Documents/Madi/Octave/Kurs/video.mp4');%���������� �����
numOfFrames = floor(vidObj.FrameRate*vidObj.Duration);
S = readFrame(vidObj);
imshow(S);
h = 10; e = 10;%������� ���������
n = input("������� ���������� ����������: ");%���� ���������� ����������
Det= zeros(n,2);
[x,y] = ginput(n);
for i = 1:n %����������� ����������
    S = insertShape(S,'Rectangle',[x(i) y(i), h,e]);
     imshow(S)
    Det(i,:) = [x(i), y(i)];
[I,J] = size(Det(i,:));  
end

S_gray = rgb2gray(S);


CurrentAvgColorSums = zeros(1,n); %����� ������� ������ �� ������� ����� 
NewAvgColorSums = zeros(1,n); %����� ������� ������ �� ����� ����� 
AllAvgColorSums = zeros(numOfFrames,n); %����� ������� ������ �� ���� ������ 
DetectorActivation = zeros(numOfFrames,n); %������������ ��������� 

sumCounter = 1;
while hasFrame(vidObj)%���������� �������� ����� � ������� �����������
   frame = readFrame(vidObj);
   S_gray = rgb2gray(frame); 
   for i = 1:n
    NewAvgColorSum = avgColorSum(S_gray,x(i), y(i), h, e);   
    AllAvgColorSums(sumCounter, i) = NewAvgColorSum;
    if(abs(CurrentAvgColorSums(i) - NewAvgColorSum)/CurrentAvgColorSums(i) > 0.17)
        DetectorActivation(sumCounter,i) = 1;
    end    
    CurrentAvgColorSums(i) = NewAvgColorSum;
    %disp ('Current frame = ' + sumCounter);
   end 
   sumCounter = sumCounter + 1;
   
end

for i = 1 : n
    AllAvgColorSums(size(AllAvgColorSums,1),i) = AllAvgColorSums((size(AllAvgColorSums,1)-1),i);
end


%����� �������� �� �����
disp ('CurrentSum');
x = 1:numOfFrames; 

figure("Name","������� ���� ���������")
tiledlayout(n,1)
for i = 1 : n
    nexttile
    plot(x,AllAvgColorSums(:,i));
    title("�������� "+i);
    xlabel('�����') 
    ylabel('������� ���� ���������') 
    ylabel('������� ���� ���������')
end
figure("Name","������� ����� � ���������")
tiledlayout(n,1)
for i = 1 : n
    nexttile
    plot(x,DetectorActivation(:,i));
    title("�������� "+i);
    xlabel('�����') 
    ylabel('������� ����������') 
end
% plot(x,DetectorActivation);

%������ � ����
% fileAllAvgColorSums = fopen('/Users/elvich/Documents/Madi/Octave/Kurs/Chek.txt','wt');
% for i = 1 : numOfFrames
%      fprintf(fileAllAvgColorSums,'%d ',AllAvgColorSums(i,:));
%      fprintf(fileAllAvgColorSums,'\n');
% end
% fclose(fileAllAvgColorSums);

