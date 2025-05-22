docker run -it --rm \
  -v $(pwd)/data:/nockchain/data \
  -v $(pwd)/wallet-data:/nockchain/data/wallet \
  -v $(pwd)/scripts:/nockchain/scripts \
  -p 3006:3006 -p 3006:3006/udp \
  madenmud/nockchain-node:latest
  #-v $(pwd)/.env:/nockchain/.env \
  #-p 3005:3005 -p 3006:3006 \
  #--name nockchain \
  # --net=macvlan \
  #--privileged \
  #--net=ipvlan \
  #--ip=192.168.0.3 \
