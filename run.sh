docker run -it --rm \
  -v $(pwd)/data:/nockchain/data \
  -v $(pwd)/wallet-data:/nockchain/data/wallet \
  -v $(pwd)/scripts:/nockchain/scripts \
  --net=ipvlan \
  madenmud/nockchain-node:latest
  #-v $(pwd)/.env:/nockchain/.env \
  #-p 3005:3005 -p 3006:3006 \
  #--name nockchain \
