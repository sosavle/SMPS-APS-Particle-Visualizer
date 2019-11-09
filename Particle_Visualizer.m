function varargout = Particle_Visualizer(varargin)
% PARTICLE_VISUALIZER MATLAB code for Particle_Visualizer.fig
%      PARTICLE_VISUALIZER, by itself, creates a new PARTICLE_VISUALIZER or raises the existing singleton*.
% 
%      H = PARTICLE_VISUALIZER returns the handle to a new PARTICLE_VISUALIZER or the handle to
%      the existing singleton*.
%
%      PARTICLE_VISUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARTICLE_VISUALIZER.M with the given input arguments.
%
%      PARTICLE_VISUALIZER('Property','Value',...) creates a new PARTICLE_VISUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Particle_Visualizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Particle_Visualizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Particle_Visualizer

% Last Modified by GUIDE v2.5 31-Mar-2019 21:31:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Particle_Visualizer_OpeningFcn, ...
                   'gui_OutputFcn',  @Particle_Visualizer_OutputFcn, ...
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

% --- Executes just before Particle_Visualizer is made visible.
function Particle_Visualizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Particle_Visualizer (see VARARGIN)

% Choose default command line output for Particle_Visualizer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
hold on;
setappdata(handles.particleMain,'smpsFile','n/a');
setappdata(handles.particleMain,'apsFile','n/a');
setappdata(handles.particleMain,'resolution', 10);

% Initialize context menu
cMenu = uicontextmenu;
handles.particleMain.UIContextMenu = cMenu;
handles.plotArea.UIContextMenu = cMenu;
uimenu(cMenu,'Label','Copy screen','Callback',@copy2Clipboard);  
uimenu(cMenu,'Label','Copy graph only','Callback',@copy2Clipboard);



% UIWAIT makes Particle_Visualizer wait for user response (see UIRESUME)
% uiwait(handles.particleMain);

% --- Outputs from this function are returned to the command line.
function varargout = Particle_Visualizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function smpsDir_Callback(hObject, eventdata, handles)
% hObject    handle to smpsDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smpsDir as text
%        str2double(get(hObject,'String')) returns contents of smpsDir as a double


% --- Executes during object creation, after setting all properties.
function smpsDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smpsDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function apsDir_Callback(hObject, eventdata, handles)
% hObject    handle to apsDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of apsDir as text
%        str2double(get(hObject,'String')) returns contents of apsDir as a double


% --- Executes during object creation, after setting all properties.
function apsDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apsDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function resolutionButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolutionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% INITIALIZATION AND UNUSED CALLBACKS Å™
%%    ACTUAL PROGRAM STARTS HERE Å´   

function plotParticles(hObject, eventdata, handles, directory, mode)
hold off;

tic
% Read file and generate a temporary modification file.
 originalFile = fopen(directory,'r+');
 tempFile = 'Ptemp.txt';
 formattedFile = fopen(tempFile,'w');

% Discard Header Lines, 14 for SMPS files and 7 for APS files.
 if mode == "SMPS"
    for i=1:14
      fgets(originalFile); 
    end 
    
 elseif mode == "APS"
     for i=1:7
         fgets(originalFile); 
     end 
 end
 
% Furthermore, force tab separated files into comma separated files
 noHeader = fscanf(originalFile,'%c');
 noHeader = regexprep(noHeader,'\t',',');
% Newly formatted file is saved into Ptemp.txt
 fprintf(formattedFile,noHeader);
 fclose(formattedFile);
 fclose(originalFile);

% Set appropiate import options for file
opts = detectImportOptions(tempFile);
if mode == "SMPS"
    opts.DataLines = [4,109];
elseif mode == "APS"
    opts.DataLines = [5,55];
end

% Read data as a table, then convert to numerical array for analysis
particleData = readtable(tempFile,opts);
particleData = table2array(particleData);
dataSize = size(particleData,2);

% Modify opts to read strings instead of doubles for datetime data 
opts.DataLines = [1,2];
stringPlaceholder = cell(1,dataSize);
for i = 1:dataSize
   stringPlaceholder(1,i) = {'string'};
end
opts.VariableTypes = stringPlaceholder;

% Read datetime data
timeData = readtable(tempFile, opts);
dates = table2array(timeData(1,2:dataSize));
times = table2array(timeData(2,2:dataSize));


% fullTime is the time LABEL to be used in graph
% numTime is its numerical equivalent to determine position in x axis.
fullTime = strings(dataSize-1,1);
numTime = zeros(dataSize-1,1);
% Avoid displaying the date label unless the date has changed
for i=1:dataSize-1
    if (i~=1 && dates(i) == dates(i-1))
        fullTime(i) = " " + times(i) + " ";
    else
       fullTime(i) = times(i) + '\newline' + dates(i);
    end
    numTime(i) = datenum(strcat(dates(i) + " " + times(i))); 
end
toc
% The contour plot axes are:
x = numTime; 
setappdata(handles.particleMain,'x',x); 
setappdata(handles.particleMain,'timeLabels',fullTime);

y = particleData(:,1); 
setappdata(handles.particleMain,'y',y);

z = particleData(:,2:end); 
setappdata(handles.particleMain,'z',z);

n = getappdata(handles.particleMain,'resolution');

contourf(x, y, z, n, 'LineColor','none')

% Miscellaneous plot formatting
c = colorbar;
c.Label.String = '\newlineNumber of Particles';
ax = gca;
set(ax,'xticklabel',fullTime.');
set(ax, 'YScale', 'log');
set(ax,'TickDir','out');
set(ax,'box','off');
xlabel('\newlineTime');
if mode == "SMPS"
    ylabel('Particle Diameter (nm)');
elseif mode == "APS"
    ylabel('Particle Diameter(um)');
end
delete 'Ptemp.txt';

function refreshPlot(handles, mode)
x = getappdata(handles.particleMain,'x');
fullTime = getappdata(handles.particleMain, 'timeLabels');
y = getappdata(handles.particleMain,'y');
z = getappdata(handles.particleMain,'z');
n = getappdata(handles.particleMain,'resolution');
contourf(x,y,z,n,'LineColor','none');

% Miscellaneous plot formatting
c = colorbar;
c.Label.String = '\newlineNumber of Particles';
ax = gca;
set(ax,'xticklabel',fullTime.');
set(ax, 'YScale', 'log');
set(ax,'TickDir','out');
set(ax,'box','off');
xlabel('\newlineTime');
if mode == "SMPS"
    ylabel('Particle Diameter (nm)');
elseif mode == "APS"
    ylabel('Particle Diameter(um)');
end


% --- Executes on button press in browseSMPS.
function browseSMPS_Callback(hObject, eventdata, handles)
% hObject    handle to browseSMPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path] = uigetfile({'*.txt';'*.csv'});
if ischar(file) && ischar(path)
    set(handles.smpsDir, 'string', file);
    set(handles.apsDir, 'string', 'APS File');
    setappdata(handles.particleMain,'smpsFile',file);
    setappdata(handles.particleMain,'apsFile',"n/a");
    directory = fullfile(path,file);
    plotParticles(hObject, eventdata, handles, directory, "SMPS");
end

% --- Executes on button press in browseAPS.
function browseAPS_Callback(hObject, eventdata, handles)
% hObject    handle to browseAPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path] = uigetfile({'*.txt';'*.csv'});
if ischar(file) && ischar(path)
    setappdata(handles.apsDir, 'string', file);
    setappdata(handles.smpsDir, 'string', 'SMPS File');
    setappdata(handles.particleMain,'apsFile',file);
    setappdata(handles.particleMain,'smpsFile',"n/a");
    directory = fullfile(path,file);
    plotParticles(hObject, eventdata, handles, directory, "APS");
end

% --------------------------------------------------------------------
function clearAll_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to clearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset;
set(handles.smpsDir, 'string', 'SMPS File');
set(handles.apsDir, 'string', 'APS File');

% --------------------------------------------------------------------
function saveGraph_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

smpsFile = getappdata(handles.particleMain, 'smpsFile');
apsFile = getappdata(handles.particleMain, 'apsFile');

if smpsFile ~= "n/a"
    saveName = smpsFile(1:end-4);
elseif apsFile ~= "n/a"
    saveName = apsFile(1:end-4);
else
    error('There is no plot to save!');
end

[filename,path] = uiputfile('*.png','Save as Image', saveName);
if ischar(file) && ischar(path)
    print(strcat(path,filename),'-noui','-dpng');
end


% --- Executes on selection change in resolutionButton.
function resolutionButton_Callback(hObject, eventdata, handles)
% hObject    handle to resolutionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns resolutionButton contents as cell array
%        contents{get(hObject,'Value')} returns selected item from resolutionButton

option = get(hObject,'Value');

if option == 1
    resolution = 5;
elseif option == 2
    resolution = 10;
elseif option == 3
    resolution = 50;
end

setappdata(handles.particleMain,'resolution',resolution);
smpsCheck = getappdata(handles.particleMain,'smpsFile');
apsCheck = getappdata(handles.particleMain,'apsFile');

if smpsCheck ~= "n/a"
    refreshPlot(handles,"SMPS");
elseif apsCheck ~= "n/a"
    refreshPlot(handles,"APS");
end

function copy2Clipboard(source,callbackdata)

% Enhanced Clipboard copy functionality is only available in Windows OS
% according to Matlab help menu for the print function

if ispc
    copyType = '-dmeta';
else
    copyType = '-dbitmap';
end

switch source.Label
    case 'Copy screen'
       print('-clipboard',copyType);
    case 'Copy graph only'
        print('-clipboard', copyType ,'-noui');
end
