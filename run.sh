docker run -it --rm \
  -v $(pwd)/wallet-data:/nockchain/data/wallet \
  -v $(pwd)/scripts:/nockchain/scripts \
  --name nockchain \
  madenmud/nockchain-node:latest
