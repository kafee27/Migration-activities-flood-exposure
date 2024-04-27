clc
clear all

filename = 'H:\aphdpaper\paper6\cmfd\feikai3.nc'

ncdisp(filename)
Lon = ncread(filename,'lon'); %读取经度数据
Lat = ncread(filename,'lat');
TIME = ncread(filename,'time');
%tp = ncread(filename,'tp');

long = 1;
lati = 1;
time = 1;
%level = 1;
start = [long,lati,time];     % varname所指定变量的每一维的开始读取的位置 
% 6:time维度从6开始，只读1个； 473：time维度从473开始，只读1个（count）
stride = [1, 1, 1];   % 从start开始，每一维读取的数目为count时，每一维的读取的步长
count = [700, 400,1];   % 从start指定的开始位置算起，一共读取的每一维要素的数目
% blh = ncread(filename,'t',start, count, stride);   % 边界层高度属性
% t        
%            Size:       1440x721x6x473
%            Dimensions: longitude,latitude,level,time
%            Datatype:   int16
%            Attributes:
%                        scale_factor  = 0.0020267
%                        add_offset    = 252.4038
%                        _FillValue    = -32767
%                        missing_value = -32767
%                        units         = 'K'
%                        long_name     = 'Temperature'
%                        standard_name = 'air_temperature'

for time = 1:length(TIME)
    time
    start=[long,lati,time]
    count
    stride
    temp_level_time = ncread(filename,'prec',start, count, stride);   % 边界层高度属性
    %temp_level_time = ncread(filename,'pr',start, count, stride);   % 边界层高度属性
    time1990 = datenum('1900-01-01 00:00:00.0');     % era5是从公元0年到1900-01-01所经历的日数
    nowtime = double(time1990 + double(TIME(time))/24) ;%小事数据除24，日数据不管
    A=double(TIME(time))/24
    date1 = datestr(nowtime,'yyyymmddhh')   % 将天数转化为日期  注意：只接受双精度型date number
    savename = strcat(date1, 'cntp.tif');
    savepath = strcat('H:\aphdpaper\paper6\cmfd\output\', savename)
    GeoRef = georasterref('Rastersize',[400,700],'Latlim',[15,55],'Lonlim',[70,140]);%era5是0,360
    geotiffwrite(savepath,flipud(rot90(temp_level_time)),GeoRef)%这个rot90得测试一下
    %geotiffwrite(savepath,rot90(temp_level_time),GeoRef)%这个rot90得测试一下
end