export $(grep -v '^#' .env | xargs)
echo $MINING_PUBKEY
nockchain --mining-pubkey $MINING_PUBKEY --mine 
