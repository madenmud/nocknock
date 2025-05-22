export $(grep -v '^#' .env | xargs)
echo $MINING_PUBKEY



# Define environment variables
PEERS="/ip4/95.216.102.60/udp/3006/quic-v1 /ip4/65.108.123.225/udp/3006/quic-v1 /ip4/65.109.156.108/udp/3006/quic-v1 /ip4/65.21.67.175/udp/3006/quic-v1 /ip4/65.109.156.172/udp/3006/quic-v1 /ip4/34.174.22.166/udp/3006/quic-v1 /ip4/34.95.155.151/udp/30000/quic-v1 /ip4/34.18.98.38/udp/30000/quic-v1"
MAX_INCOMING=1000
MAX_OUTGOING=1000
MAX_ESTABLISHED=2000
MAX_PER_PEER=10

# Export variables to make them available to the command
export PEERS MAX_INCOMING MAX_OUTGOING MAX_ESTABLISHED MAX_PER_PEER

# Execute the nockchain command
rm -f "$NPC_SOCKET" && /root/.cargo/bin/nockchain --npc-socket "$NPC_SOCKET" --mining-pubkey "$MINING_PUBKEY" --bind /ip4/0.0.0.0/udp/"$BIND_PORT"/quic-v1 --mine --peer `echo $PEERS | sed 's/ / --peer /g'` --max-established-incoming "$MAX_INCOMING" --max-established-outgoing "$MAX_OUTGOING" --max-established "$MAX_ESTABLISHED" --max-established-per-peer "$MAX_PER_PEER"

