function DLR_recon(in)
disp("无显卡设备重建时间会较长，请耐心等待！")
in=char(in);
net=load("DLRAI.mat").net;
DLR(in,'-DLR-hzr',net)

end