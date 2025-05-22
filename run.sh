docker run -it --rm \
  -v $(pwd)/data:/nockchain/data \
  -v $(pwd)/wallet-data:/nockchain/data/wallet \
  -v $(pwd)/scripts:/nockchain/scripts \
  --name nockchain \
  --net=ipvlan \
  madenmud/nockchain-node:latest
  #-v $(pwd)/.env:/nockchain/.env \
