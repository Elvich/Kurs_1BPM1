close all;clear all;clc;

vidObj = VideoReader('/Users/elvich/Documents/Madi/Octave/Kurs/video.mp4');%Считывание видео
numOfFrames = floor(vidObj.FrameRate*vidObj.Duration);
S = readFrame(vidObj);
imshow(S);
h = 10; e = 10;%Размеры детектора
n = input("Введите количество детекторов: ");%Ввод количество детекторов
Det= zeros(n,2);
[x,y] = ginput(n);
for i = 1:n %Выставление детекторов
    S = insertShape(S,'Rectangle',[x(i) y(i), h,e]);
     imshow(S)
    Det(i,:) = [x(i), y(i)];
[I,J] = size(Det(i,:));  
end

S_gray = rgb2gray(S);


CurrentAvgColorSums = zeros(1,n); %Сумма средних цветов на текущем кадре 
NewAvgColorSums = zeros(1,n); %Сумма средних цветов на новом кадре 
AllAvgColorSums = zeros(numOfFrames,n); %Сумма средних цветов по всем кадрам 
DetectorActivation = zeros(numOfFrames,n); %Срабатывание детектора 

sumCounter = 1;
while hasFrame(vidObj)%Вычесление среднего цвета и наличее автомобилей
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


%Вывод графиков на экран
disp ('CurrentSum');
x = 1:numOfFrames; 

figure("Name","Средний цвет детектора")
tiledlayout(n,1)
for i = 1 : n
    nexttile
    plot(x,AllAvgColorSums(:,i));
    title("Детектор "+i);
    xlabel('Кадры') 
    ylabel('Средний цвет детектора') 
    ylabel('Средний цвет детектора')
end
figure("Name","Надичее машин в детекторе")
tiledlayout(n,1)
for i = 1 : n
    nexttile
    plot(x,DetectorActivation(:,i));
    title("Детектор "+i);
    xlabel('Кадры') 
    ylabel('Наличие автомобиля') 
end
% plot(x,DetectorActivation);

%Запись в файл
% fileAllAvgColorSums = fopen('/Users/elvich/Documents/Madi/Octave/Kurs/Chek.txt','wt');
% for i = 1 : numOfFrames
%      fprintf(fileAllAvgColorSums,'%d ',AllAvgColorSums(i,:));
%      fprintf(fileAllAvgColorSums,'\n');
% end
% fclose(fileAllAvgColorSums);

