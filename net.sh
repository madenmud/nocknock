#!/bin/bash

# 인터넷에 연결된 인터페이스 찾기
INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n 1)

if [ -z "$INTERFACE" ]; then
  echo "인터넷에 연결된 인터페이스를 찾을 수 없습니다."
  exit 1
fi

# 인터페이스의 IP와 서브넷 마스크 찾기
IP_INFO=$(ip -o addr show "$INTERFACE" | awk '/inet / {print $4}' | head -n 1)

if [ -z "$IP_INFO" ]; then
  echo "인터페이스 $INTERFACE의 IP 정보를 찾을 수 없습니다."
  exit 1
fi

# IP와 서브넷 마스크 분리 (예: 192.168.0.88/24 -> IP: 192.168.0.88, MASK: 24)
IP=$(echo "$IP_INFO" | cut -d'/' -f1)
MASK=$(echo "$IP_INFO" | cut -d'/' -f2)

# 네트워크 주소 계산
# IP를 옥텟으로 분리
IFS='.' read -r i1 i2 i3 i4 <<< "$IP"
# 서브넷 마스크에 따라 네트워크 주소 계산 (예: /24 -> 마지막 옥텟을 0으로)
case $MASK in
  24)
    NETWORK="$i1.$i2.$i3.0/$MASK"
    ;;
  *)
    echo "지원되지 않는 서브넷 마스크: /$MASK (현재 /24만 지원)"
    exit 1
    ;;
esac

# 게이트웨이 찾기
GATEWAY=$(ip route | grep '^default' | awk '{print $3}' | head -n 1)

if [ -z "$GATEWAY" ]; then
  echo "게이트웨이를 찾을 수 없습니다."
  exit 1
fi

# Docker 네트워크 생성
docker network create -d ipvlan \
  --subnet="$NETWORK" \
  --gateway="$GATEWAY" \
  -o parent="$INTERFACE" \
  ipvlan

echo "Docker 네트워크 'ipvlan'이 인터페이스 $INTERFACE에 생성되었습니다."
echo "서브넷: $NETWORK, 게이트웨이: $GATEWAY"

