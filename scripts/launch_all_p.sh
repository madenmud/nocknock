#!/bin/bash
NUM_INSTANCES=50
START_PORT=3008
PUBKEY="3k9rHCq3n8ZAxHqiaTprTe5eoTaqzx8oSP9irqNvppE9gMjxyG9RfJHEg7jgVaPvjjfjwDxiNwZqGbuDyaF5UwriSzNWr1iuPNTzr9qm7fKEpJVbHr9WTzmNf2ppZ87EzvQ4"

for ((i=1; i<=NUM_INSTANCES; i++)); do
  DIR="node$(printf "%02d" $i)"
  PORT=$((START_PORT + i - 1))

  mkdir -p "$DIR"
  cp ./target/release/nockchain "$DIR/"
  cp .env "$DIR/"

  echo "시작 $DIR, 포트 $PORT 사용"
  screen -dmS "$DIR" bash -c "
    cd $DIR && \
    env RUST_LOG=info,nockchain=debug MINIMAL_LOG_FORMAT=true \
    ./nockchain --mine \
      --mining-pubkey $PUBKEY \
      --bind /ip4/0.0.0.0/udp/$PORT/quic-v1 \
      --peer /ip4/95.216.102.60/udp/3006/quic-v1 \
      --peer /ip4/65.108.123.225/udp/3006/quic-v1 \
      --peer /ip4/65.109.156.108/udp/3006/quic-v1 \
      --peer /ip4/65.21.67.175/udp/3006/quic-v1 \
      --peer /ip4/65.109.156.172/udp/3006/quic-v1 \
      --peer /ip4/34.174.22.166/udp/3006/quic-v1 \
      --peer /ip4/34.95.155.151/udp/30000/quic-v1 \
      --peer /ip4/34.18.98.38/udp/30000/quic-v1 >> nockchain_$i.log 2>&1
  "
done
