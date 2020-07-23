%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%程序名称：Calterah_adcData_analysis_main.m
%程序功能：ADC数据分析程序（主程序）；
%创    建：V1.0.0 2019/08/23 加特兰微电子科技（深圳）有限公司 AE部
%备    注：
%修改记录：
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; 
close all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('.\subFunc_lib');
%%%%%%%%%%%%%%%%%%%%%%%%%%% 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%
%配置文件
cfg_file_pathName       = '.\cfg\';
cfg_file_fileName       = 'sensor_config_init0.hxx';
cfg_file_fullName       = [cfg_file_pathName cfg_file_fileName];

%数据文件
data_file_pathName      = '.\data\';
data_file_fileName      = '20190823095839Capture.dat';
data_file_fullName      = [data_file_pathName data_file_fileName];

%分析第frameID帧数据
frameID                 = 1;  %帧号

%%%%%%%%%%%%%%%%%%%%%%%%%% 数据分析 %%%%%%%%%%%%%%%%%%%%%%%%%%
%[step1]：获取配置参数
[radarParam]            = radarParam_getFunc(cfg_file_fullName);

%[step2]：获取单帧ADC数据，数据格式：距离维 X 脉冲维 X 虚拟后接收通道数
[echo]     = dataRead_func(radarParam, data_file_fullName, frameID);
rawEcho_dispFunc(radarParam, echo);%画图

%[step3]：距离维FFT
[echo_fft_1D]  = R_FFT_func(radarParam, echo);
R_FFT_dispFunc(radarParam, echo_fft_1D);%画图

%[step4]：速度维FFT
[echo_fft]    = V_FFT_func(radarParam, echo_fft_1D);
V_FFT_dispFunc(radarParam, echo_fft); %画图

%[step4]：波束合成
[RV_image]  = DBF_func(radarParam, echo_fft);
DBF_dispFunc(radarParam, RV_image);%画图

%[step6]：CFAR
[cfar_list, cfar_out, gate_out]  = OS_CFAR_2D_interval_Calterah_func(radarParam, RV_image, 16, 64, 3);
CFAR_dispFunc(radarParam, RV_image, cfar_out, gate_out, 93, radarParam.vel_nfft/2+1);%画图

%[step7]：测角
[detect_list]   = angleCalc_func(radarParam, cfar_list, echo_fft, [-60, 60]);
radarShow_func(radarParam, detect_list);%画图


xxx=1;
