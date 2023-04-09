%%汉明滤波
function out=Lpf_hanning(in,width)
k_space=fftshift(fft2(in));
[sizex,sizey]=size(in);
hanning=get_hanning(width,sizex,sizey);
g=k_space.*hanning;
out=ifft2(fftshift(g));
end
%%


%%
%%获得一个中心宽度为width大小为size的汉明窗口
function hanning=get_hanning(width,sizex,sizey)

M_x=width/2;
M_y=width/2;
S=zeros(width,width);
a=0.5;
for c_x=1:width
    for c_y=1:width
        Distance=sqrt((M_x-c_x)^2+(M_y-c_y)^2);
        if Distance<=M_x
            S(c_x,c_y)=a+(1-a)*cos(2*pi*Distance/width);
            
        end
    end
end
hanning=padarray(S, [(sizex-width)/2,(sizey-width)/2],0);


end
