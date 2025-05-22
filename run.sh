docker run -it --rm \
  -v $(pwd)/data:/nockchain/data \
  -v $(pwd)/wallet-data:/nockchain/data/wallet \
  -v $(pwd)/scripts:/nockchain/scripts \
  -v $(pwd)/.env:/nockchain/.env \
  --name nockchain \
  --net vlan \
  madenmud/nockchain-node:latest
