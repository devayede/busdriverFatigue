function varargout = bus11(varargin)
% BUS11 MATLAB code for bus11.fig
%      BUS11, by itself, creates a new BUS11 or raises the existing
%      singleton*.
%
%      H = BUS11 returns the handle to a new BUS11 or the handle to
%      the existing singleton*.
%
%      BUS11('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUS11.M with the given input arguments.
%
%      BUS11('Property','Value',...) creates a new BUS11 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bus11_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bus11_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bus11

% Last Modified by GUIDE v2.5 10-Oct-2017 17:06:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bus11_OpeningFcn, ...
                   'gui_OutputFcn',  @bus11_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bus11 is made visible.
function bus11_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bus11 (see VARARGIN)

% Choose default command line output for bus11
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bus11 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bus11_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

% initialize webcam (read instructions if required 'README_TO_SET_YOUR_CAMERA.m')

clc 
clear all; 
close all;

% initialize webcam (read instructions if required 'README_TO_SET_YOUR_CAMERA.m')

vobj=videoinput('winvideo',1,'YUY2_640x480','ReturnedColorSpace','rgb'); 
figure('Name','Preview Window'); 
uicontrol('string','close','callback','close(gcf)');

% create an image object for previewing

vidRes=get(vobj,'VideoResolution'); 
nBands=get(vobj,'NumberOfBands'); 
hImage=image(zeros(vidRes(2),vidRes(1),nBands)); 
preview(vobj,hImage);

%pause 
% coordinates to draw lines

rs=vidRes(2); 
cs=vidRes(1); 
C1=floor(cs/6); 
C2=floor(267*cs/320);

C3=floor(0); 
C4=floor(cs);

R1=floor(rs/4); 
R2=floor(rs/2); 
R3=floor(3*rs/4); 
R4=floor(rs);

x1=[C1 C1]; 
x2=[C2 C2]; 
x3=[C3 C3]; 
x4=[C4 C4];

x5=[C3 C4];

y1=[0 rs]; 
y2=[R1 R1]; 
y3=[R2 R2]; 
y4=[R3 R3]; 
y5=[R4 R4];

%draw lines

line(x1,y1,'color','r','LineWidth',2) 
line(x2,y1,'color','r','LineWidth',2)

line(x3,y1,'color','g','LineWidth',2) 
line(x4,y1,'color','g','LineWidth',2)

line(x5,y2,'color','g','LineWidth',2) 
line(x5,y3,'color','g','LineWidth',2) 
line(x5,y4,'color','g','LineWidth',2)

line(x5,y5,'color','w','LineWidth',2)

% write text

text1=text(19*cs/96,rs/8,'FOREHEAD REGION','color','r'); 
text2=text(19*cs/96,3*rs/8,'EYE REGION','color','r'); 
text3=text(19*cs/96,5*rs/8,'NOSE REGION','color','r'); 
text4=text(19*cs/96,7*rs/8,'MOUTH REGION','color','r'); 
% initialize flags

FlagForHead=0; 
FlagEyes=0; 
FlagNose=0; 
FlagMouth=0;

cnt=0;

% initialize vision toolbox

shape=vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]); 
EyeDetector1=vision.CascadeObjectDetector('EyePairSmall'); 
NoseDetector=vision.CascadeObjectDetector('Nose'); 
MouthDetector1=vision.CascadeObjectDetector('Mouth');

%% press any key while you are ready

for i=1:50 % for 200 frames, increse/decrese if required 
I2=getsnapshot(vobj); 
pause(0.5) 
FirstSeg=imcrop(I2,[C1 0 C2-C1 R1]); 
% figure(2),subplt(1,2,1);imshow(FirstSeg); 

BlackDetect=(FirstSeg(:,:,1)<70)&(FirstSeg(:,:,2)<70)&(FirstSeg(:,:,3)<70); 
BW1=imfill(BlackDetect,'holes'); 
BW2=bwareaopen(BW1,2000); 
subplot(1,2,2),imshow(BW2); 
[Matl Nr]=bwlabel(BW2); 
if Nr~=0 
FlagForHead=1; 
else 
FlagForHead=0; 
end 
SecondSegment=imcrop(I2,[C1 R1 C2-C1 R2-R1]); 
figure(3),subplot(1,2,1),imshow(SecondSegment); 
bbox_eye1=step(EyeDetector1,SecondSegment); 
I_Eye=step(shape,SecondSegment,int32(bbox_eye1)); 
if isempty(bbox_eye1)~=1 
FlagEyes=1; 
EyeRegion=imcrop(SecondSegment,[bbox_eye1(1,1),bbox_eye1(1,2),bbox_eye1(1,3),bbox_eye1(1,4)]); 
subplot(3,2,1),imshow(I_Eye),title('EYE INPUT'); 
subplot(1,2,2),imshow(EyeRegion),title('EYE REGION'); 
else 
FlagEyes=0; 
end; 
ThirdSegment=imcrop(I2,[C1 R2 C2-C1 R3-R2]); 
figure(4),subplot(1,2,1),imshow(ThirdSegment); 
bbox_Nose1=step(NoseDetector,ThirdSegment); 
I_Nose=step(shape,ThirdSegment,int32(bbox_Nose1)); 
if isempty(bbox_Nose1)~=1 
FlagNose=1; 
% 
NoseRegion=imcrop(ThirdSegment,[bbox_Nose1(1,1),bbox_Nose1(1,2),bbox_Nose1(1,3),bbox_Nose1(1,4)]); 
subplot(3,2,5),imshow(I_Nose),title('Nose INPUT'); 
subplot(1,2,2),imshow(NoseRegion),title('Nose REGION'); 
else 
FlagNose=0; 
end; 
FourthSegment=imcrop(I2,[C1 R3 C2-C1 R4-R3]); 
figure(5),subplot(1,2,1),imshow(FourthSegment); 
bbox_Mouth1=step(MouthDetector1,FourthSegment); 
I_Mouth=step(shape,FourthSegment,int32(bbox_Mouth1)); 
if isempty(bbox_Mouth1)~=1 
FlagMouth=1; 
% 
MouthRegion=imcrop(FourthSegment,[bbox_Mouth1(1,1),bbox_Mouth1(1,2),bbox_Mouth1(1,3),bbox_Mouth1(1,4)]); 
subplot(3,2,3),imshow(I_Mouth),title('MOUTH INPUT'); 
subplot(1,2,2),imshow(MouthRegion),title('MOUTH REGION'); 
else 
FlagMouth=0; 
end; 
if ((FlagForHead==1)&&(FlagEyes==1)&&(FlagNose==1)&&(FlagMouth==1)) 
disp('Normal Condition') 

cnt=0; 
else 
disp('possible drowsiness detection') 
cnt=cnt+1; 
dr=cnt/Nr;
x = 0:1:5;
y = tan(sin(x)) - sin(tan(x));
plot(x,cnt,'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
 %figure
    plot(dr,cnt);
end 
if cnt>3
   tts('Hello Dev Wake up ');
   
else
disp('drowsiness confirmed') 

end 
end
